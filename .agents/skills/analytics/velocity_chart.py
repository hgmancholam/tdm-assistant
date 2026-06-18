"""
velocity_chart.py — Sprint velocity and commitment ratio chart.

Input (stdin JSON):
  {
    "projectCode": "ALPHA",
    "sprints": [
      { "name": "Sprint 1", "committed": 40, "completed": 35 },
      { "name": "Sprint 2", "committed": 38, "completed": 40 }
    ]
  }

Output: saves PNG to projects/<CODE>/reports/velocity-<date>.png
        prints JSON result to stdout
"""

import sys, json, argparse
from datetime import date
from pathlib import Path

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches


def run(data: dict, output_dir: Path) -> dict:
    sprints = data.get("sprints", [])
    code    = data.get("projectCode", "PROJECT")

    if len(sprints) < 2:
        return {"success": False, "error": "Need at least 2 sprints to generate a chart."}

    df = pd.DataFrame(sprints)
    required = {"name", "committed", "completed"}
    if not required.issubset(df.columns):
        return {"success": False, "error": f"Missing fields. Required: {required}"}

    df["ratio"] = (df["completed"] / df["committed"] * 100).round(1)
    avg_velocity = df["completed"].mean().round(1)

    # ── Chart ──────────────────────────────────────────────────────────────────
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 7), gridspec_kw={"height_ratios": [3, 1]})
    fig.patch.set_facecolor("#1e1e2e")
    for ax in (ax1, ax2):
        ax.set_facecolor("#1e1e2e")
        ax.tick_params(colors="white")
        for spine in ax.spines.values():
            spine.set_edgecolor("#444")

    x   = range(len(df))
    w   = 0.35
    bar_committed = ax1.bar([i - w/2 for i in x], df["committed"], w, color="#4e9af1", alpha=0.7, label="Committed")
    bar_completed = ax1.bar([i + w/2 for i in x], df["completed"], w, color="#50fa7b", alpha=0.9, label="Completed")

    ax1.plot(x, df["completed"], "o--", color="#f8f8f2", linewidth=1.5, markersize=5, label="Velocity trend")
    ax1.axhline(avg_velocity, color="#ff79c6", linestyle=":", linewidth=1.5, label=f"Avg velocity ({avg_velocity})")

    ax1.set_xticks(x)
    ax1.set_xticklabels(df["name"], color="white", fontsize=9)
    ax1.set_ylabel("Story Points", color="white")
    ax1.set_title(f"{code} — Sprint Velocity", color="white", fontsize=13, pad=12)
    ax1.legend(facecolor="#2a2a3e", labelcolor="white", fontsize=8)
    ax1.yaxis.label.set_color("white")

    # Commitment ratio bar
    colors = ["#50fa7b" if r >= 85 else "#f1fa8c" if r >= 70 else "#ff5555" for r in df["ratio"]]
    ax2.bar(x, df["ratio"], color=colors, alpha=0.85)
    ax2.axhline(85, color="#50fa7b", linestyle=":", linewidth=1)
    ax2.axhline(70, color="#ff5555", linestyle=":", linewidth=1)
    ax2.set_xticks(x)
    ax2.set_xticklabels(df["name"], color="white", fontsize=8)
    ax2.set_ylabel("Commit %", color="white")
    ax2.set_ylim(0, 130)
    ax2.yaxis.label.set_color("white")

    for i, (val, bar) in enumerate(zip(df["ratio"], ax2.patches)):
        ax2.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 2,
                 f"{val}%", ha="center", color="white", fontsize=8)

    green  = mpatches.Patch(color="#50fa7b", label="≥85% healthy")
    yellow = mpatches.Patch(color="#f1fa8c", label="70-85% attention")
    red    = mpatches.Patch(color="#ff5555", label="<70% critical")
    ax2.legend(handles=[green, yellow, red], facecolor="#2a2a3e", labelcolor="white", fontsize=7, loc="upper right")

    plt.tight_layout(pad=1.5)

    output_dir.mkdir(parents=True, exist_ok=True)
    filename = output_dir / f"velocity-{date.today().isoformat()}.png"
    plt.savefig(filename, dpi=150, bbox_inches="tight", facecolor=fig.get_facecolor())
    plt.close()

    return {
        "success":     True,
        "chartPath":   str(filename),
        "avgVelocity": avg_velocity,
        "lastRatio":   df["ratio"].iloc[-1],
        "trend":       "up" if df["completed"].iloc[-1] > df["completed"].iloc[-2] else "down"
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--project-code", default=None)
    parser.add_argument("--output-dir",   default=None)
    args = parser.parse_args()

    raw  = sys.stdin.read().strip()
    data = json.loads(raw) if raw else {}

    if args.project_code:
        data["projectCode"] = args.project_code

    code       = data.get("projectCode", "PROJECT")
    output_dir = Path(args.output_dir) if args.output_dir else Path("projects") / code / "reports"

    result = run(data, output_dir)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
