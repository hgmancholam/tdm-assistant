"""
evm_report.py — Earned Value Management calculations and chart.

Input (stdin JSON):
  {
    "projectCode":     "ALPHA",
    "projectName":     "My Project",
    "bac":             100000,
    "percentComplete": 45,
    "actualCost":      52000,
    "plannedPercentAtDate": 50,
    "currency":        "USD"
  }

Output: JSON with EVM metrics + optional PNG chart
"""

import sys, json, argparse
from datetime import date
from pathlib import Path

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches


def calculate_evm(bac: float, pct_complete: float, ac: float, planned_pct: float) -> dict:
    ev  = bac * (pct_complete / 100)
    pv  = bac * (planned_pct  / 100)

    cv  = ev - ac
    sv  = ev - pv
    cpi = ev / ac      if ac  > 0 else None
    spi = ev / pv      if pv  > 0 else None
    eac = bac / cpi    if cpi else None
    etc = eac - ac     if eac else None
    vac = bac - eac    if eac else None
    tcpi = (bac - ev) / (bac - ac) if (bac - ac) > 0 else None

    def status(val, *, higher_is_better=True):
        if val is None: return "N/A"
        if higher_is_better:
            return "green" if val >= 1.0 else "yellow" if val >= 0.9 else "red"
        else:
            return "green" if val <= 1.0 else "yellow" if val <= 1.1 else "red"

    return {
        "bac":    round(bac,  2),
        "ev":     round(ev,   2),
        "pv":     round(pv,   2),
        "ac":     round(ac,   2),
        "cv":     round(cv,   2),
        "sv":     round(sv,   2),
        "cpi":    round(cpi,  3) if cpi else None,
        "spi":    round(spi,  3) if spi else None,
        "eac":    round(eac,  2) if eac else None,
        "etc":    round(etc,  2) if etc else None,
        "vac":    round(vac,  2) if vac else None,
        "tcpi":   round(tcpi, 3) if tcpi else None,
        "cpiStatus":  status(cpi),
        "spiStatus":  status(spi),
    }


def generate_chart(metrics: dict, project_name: str, currency: str, output_path: Path):
    labels = ["BAC", "EV", "PV", "AC"]
    values = [metrics["bac"], metrics["ev"], metrics["pv"], metrics["ac"]]
    colors = ["#4e9af1", "#50fa7b", "#f1fa8c", "#ff79c6"]

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))
    fig.patch.set_facecolor("#1e1e2e")
    for ax in (ax1, ax2):
        ax.set_facecolor("#1e1e2e")
        ax.tick_params(colors="white")
        for spine in ax.spines.values():
            spine.set_edgecolor("#444")

    bars = ax1.bar(labels, values, color=colors, alpha=0.85, width=0.5)
    ax1.set_title(f"{project_name} — EVM Snapshot", color="white", fontsize=12)
    ax1.set_ylabel(f"Amount ({currency})", color="white")
    ax1.yaxis.label.set_color("white")
    for bar, val in zip(bars, values):
        ax1.text(bar.get_x() + bar.get_width()/2, bar.get_height() + max(values) * 0.01,
                 f"{currency} {val:,.0f}", ha="center", color="white", fontsize=9)

    # Index gauges
    indices  = []
    ind_vals = []
    ind_cols = []
    color_map = {"green": "#50fa7b", "yellow": "#f1fa8c", "red": "#ff5555", "N/A": "#888"}
    for name, key, status_key in [("CPI", "cpi", "cpiStatus"), ("SPI", "spi", "spiStatus")]:
        val = metrics.get(key)
        if val:
            indices.append(name)
            ind_vals.append(val)
            ind_cols.append(color_map.get(metrics.get(status_key, "N/A"), "#888"))

    if indices:
        ax2.bar(indices, ind_vals, color=ind_cols, alpha=0.85, width=0.4)
        ax2.axhline(1.0, color="white", linestyle="--", linewidth=1, alpha=0.5)
        ax2.set_title("Performance Indices", color="white", fontsize=12)
        ax2.set_ylabel("Index (1.0 = on target)", color="white")
        ax2.yaxis.label.set_color("white")
        for i, (name, val, col) in enumerate(zip(indices, ind_vals, ind_cols)):
            ax2.text(i, val + 0.02, f"{val:.3f}", ha="center", color="white", fontsize=11, fontweight="bold")
        ax2.set_ylim(0, max(ind_vals) * 1.3 if ind_vals else 2)

    plt.tight_layout()
    output_path.parent.mkdir(parents=True, exist_ok=True)
    plt.savefig(output_path, dpi=150, bbox_inches="tight", facecolor=fig.get_facecolor())
    plt.close()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--no-chart", action="store_true")
    parser.add_argument("--output-dir", default=None)
    args = parser.parse_args()

    raw  = sys.stdin.read().strip()
    data = json.loads(raw) if raw else {}

    code         = data.get("projectCode", "PROJECT")
    name         = data.get("projectName", code)
    bac          = float(data.get("bac",                  0))
    pct_complete = float(data.get("percentComplete",      0))
    ac           = float(data.get("actualCost",           0))
    planned_pct  = float(data.get("plannedPercentAtDate", pct_complete))
    currency     = data.get("currency", "USD")

    if bac <= 0:
        print(json.dumps({"success": False, "error": "bac must be > 0"}))
        return

    metrics = calculate_evm(bac, pct_complete, ac, planned_pct)

    chart_path = None
    if not args.no_chart:
        output_dir = Path(args.output_dir) if args.output_dir else Path("projects") / code / "reports"
        chart_path = output_dir / f"evm-{date.today().isoformat()}.png"
        generate_chart(metrics, name, currency, chart_path)
        chart_path = str(chart_path)

    print(json.dumps({"success": True, "metrics": metrics, "chartPath": chart_path}, indent=2))


if __name__ == "__main__":
    main()
