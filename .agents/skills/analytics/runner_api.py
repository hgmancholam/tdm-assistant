"""
runner_api.py — Richer automation runner using the Anthropic SDK directly.

Replaces the CLI-based approach in runner.ps1 for tasks that need:
  - Structured context passing
  - Programmatic response handling
  - Multi-step reasoning with tool use
  - JSON output capture without shell parsing

Usage:
  python runner_api.py --task projects-digest
  python runner_api.py --task morning-sync --project ALPHA
  python runner_api.py --task weekly-report --project ALPHA --recipients stakeholders

Environment:
  ANTHROPIC_API_KEY — required (set in .env)
  ASSISTANT_NAME    — optional (default: Friday)
"""

import sys, os, json, argparse
from datetime import datetime
from pathlib import Path

import anthropic


LOG_FILE = Path("automations.log")


def log(message: str):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    entry     = f"[{timestamp}] [runner_api] {message}\n"
    LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(entry)
    print(entry.strip(), file=sys.stderr)


def load_project_context(project_code: str) -> dict:
    settings_path = Path("projects") / project_code / "project.settings"
    if not settings_path.exists():
        return {}
    try:
        return json.loads(settings_path.read_text(encoding="utf-8"))
    except Exception:
        return {}


def build_prompt(task: str, project_code: str | None, recipients: str, context: dict) -> str:
    assistant_name = os.environ.get("ASSISTANT_NAME", "Friday")
    lines = [f"You are {assistant_name}, a TDM assistant. Execute the following automated task:"]
    lines.append(f"\nTask: {task}")

    if project_code:
        lines.append(f"Project: {project_code}")
        if context:
            lines.append(f"\nProject context:\n{json.dumps(context, indent=2)}")

    lines.append(f"\nRecipients: {recipients}")
    lines.append("\nBe concise and action-oriented. Output a structured summary of what was done.")
    return "\n".join(lines)


def run_task(task: str, project_code: str | None, recipients: str) -> dict:
    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        return {"success": False, "error": "ANTHROPIC_API_KEY not set in environment"}

    context = load_project_context(project_code) if project_code else {}
    prompt  = build_prompt(task, project_code, recipients, context)

    client = anthropic.Anthropic(api_key=api_key)

    try:
        message = client.messages.create(
            model="claude-sonnet-4-6",
            max_tokens=2048,
            messages=[{"role": "user", "content": prompt}]
        )
        response_text = message.content[0].text if message.content else ""

        result = {
            "success":      True,
            "task":         task,
            "project":      project_code,
            "recipients":   recipients,
            "response":     response_text,
            "inputTokens":  message.usage.input_tokens,
            "outputTokens": message.usage.output_tokens,
            "timestamp":    datetime.now().isoformat()
        }

        # Persist to project log if applicable
        if project_code:
            log_path = Path("projects") / project_code / "logs" / f"{datetime.now().strftime('%Y-%m-%d')}.md"
            log_path.parent.mkdir(parents=True, exist_ok=True)
            with open(log_path, "a", encoding="utf-8") as f:
                f.write(f"\n## Automated task: {task} — {datetime.now().strftime('%H:%M')}\n")
                f.write(response_text[:500] + ("..." if len(response_text) > 500 else "") + "\n")

        return result

    except anthropic.APIError as e:
        return {"success": False, "error": str(e), "task": task}


def main():
    parser = argparse.ArgumentParser(description="Anthropic SDK automation runner")
    parser.add_argument("--task",       required=True, help="Task name to execute")
    parser.add_argument("--project",    default=None,  help="Project code (optional)")
    parser.add_argument("--recipients", default="me",  help="Target audience (me/stakeholders)")
    args = parser.parse_args()

    log(f"Starting task={args.task} project={args.project} recipients={args.recipients}")
    result = run_task(args.task, args.project, args.recipients)
    log(f"Completed task={args.task} success={result['success']}")

    print(json.dumps(result, indent=2, ensure_ascii=False))
    sys.exit(0 if result["success"] else 1)


if __name__ == "__main__":
    main()
