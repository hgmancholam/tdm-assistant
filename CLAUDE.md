# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This is Harol's personal assistant system — a Claude Code-based workspace that automates and accelerates the day-to-day responsibilities of a TDM/PM at Inspyr/Arroyo Consulting. The goal is a collection of skills, slash commands, and agents that manage:

- **Email** — triage, drafting, responding (via Outlook Desktop COM automation)
- **Agenda** — calendar review, meeting prep (via Outlook Desktop COM automation)
- **Contacts** — Outlook contact lookup and management
- **Projects** — per-project workspace with logs, meeting notes, reports, and settings
- **Azure DevOps (ADO)** — work items, sprint queries, PR management, dashboards, metrics
- **Project Management** — planning, risk, budget, status reports, retrospectives, decisions

## Repository Structure

```
.claude/
  commands/               # Slash commands invocable as /command-name
  settings.json           # Permissions and tool configuration

.agents/skills/
  tdm-assistant/          # Main agent behavior definition (SKILL.md)
  outlook/                # Outlook Desktop COM scripts (email, calendar, contacts)
  projects/               # Project data management scripts (logs, notes, settings)
  agile-advisor/          # Agile Coach + TDM analysis skill
  ai-architect/           # AI & agentic architecture expert skill
  sw-architect/           # Software architecture expert skill
  runner.ps1              # Task Scheduler runner (executes tasks via claude CLI)
  scheduler.ps1           # Registers/removes/lists Windows Task Scheduler tasks

projects/
  _template/              # Template for new projects
  <PROJECT-CODE>/         # One subfolder per active project
    project.settings
    logs/
    meetings/
    decisions/
    risks/
    reports/
    retrospectives/

docs/                     # Integration guides and setup documentation
user.profile.md           # User identity, preferences, contacts — built via /tdm onboarding
reminders.json            # Active personal reminders (managed by /remind)
priorities.json           # Current top priorities (managed by /priorities)
automations.json          # Global automations (daily digest, weekly reports)
automations.log           # Automation execution log (auto-generated)
.env                      # ASSISTANT_NAME, USER_NICKNAME, Graph API (optional)
CLAUDE.md
```

## Outlook Integration (COM Automation)

Outlook email, calendar, and contacts are accessed via **Windows COM Automation** — no Azure app registration or additional auth required. Outlook Desktop must be open and authenticated.

Scripts live in `.agents/skills/outlook/` and are invoked via PowerShell:
```powershell
pwsh -File ".agents/skills/outlook/<script>.ps1" -Param value
```

All scripts output JSON. Permissions are whitelisted in `.claude/settings.json`.

## Azure DevOps Integration

ADO is accessed via the **MCP server** (mcp__ado__* tools) — no local scripts needed. Commands in `.claude/commands/ado-*.md` use these tools directly.

Base URL pattern: `https://dev.azure.com/{organization}/{project}/_apis/`

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `GRAPH_CLIENT_ID` | Microsoft Graph app client ID (optional — not required for COM) |
| `GRAPH_TENANT_ID` | Azure AD tenant ID (optional — not required for COM) |

**ADO configuration is per-project** — stored in `projects/<CODE>/project.settings` under the `ado` section:

| Campo en project.settings | Purpose |
|--------------------------|---------|
| `ado.org` | ADO organization name |
| `ado.project` | ADO project name |
| `ado.pat` | Personal Access Token for that org |
| `ado.areaPath` | Area path for work items |
| `ado.teamName` | Team name |

Each project reads its own ADO credentials — no global ADO env vars to avoid cross-project errors.

## TDM Assistant — Main Agent

The primary agent is `/tdm` — the user's personal assistant. It:

- Loads `user.profile.md` and `.env` (ASSISTANT_NAME) at the start of every session
- Runs an **onboarding flow** if the profile is not yet configured
- Routes natural-language requests to the appropriate skill or command
- Reads `reminders.json` and `priorities.json` to give proactive context
- Responds in Spanish or English (user's choice); all exportable content in **English** by default

Key files:
| File | Purpose |
|------|---------|
| `user.profile.md` | User identity, preferences, contacts, alert rules — built via onboarding |
| `reminders.json` | Active personal reminders |
| `priorities.json` | Current top-5 priorities |
| `.env` | `ASSISTANT_NAME` and `USER_NICKNAME` variables |
| `.agents/skills/tdm-assistant/SKILL.md` | Full agent behavior definition |

## Slash Commands

All commands live in `.claude/commands/` as Markdown files invocable as `/command-name`. Categories: TDM core (`/tdm`, `/brief`, `/quick-draft`, `/priorities`, `/remind`), Email & Calendar (`/email-*`, `/agenda`, `/calendar-manage`, `/contacts`), Projects (`/projects`, `/new-project`, `/project-agent`, `/projects-digest`, `/automate`), ADO (`/ado-*`), PM (`/project-plan`, `/status-report`, `/risk-register`, `/budget-review`, `/time-estimate`, `/stakeholder-update`, `/problem-solve`, `/retrospective`, `/scope-change`, `/decision-log`), Analysis (`/agile-advisor`, `/ai-architect`, `/sw-architect`), Meta (`/new-skill`).

## Python Analytics

Scripts in `.agents/skills/analytics/`: `velocity_chart.py` (sprint velocity), `evm_report.py` (EVM: CPI/SPI/EAC), `excel_report.py` (full Excel report), `runner_api.py` (Anthropic SDK automation runner). Install: `pip install -r .agents/skills/analytics/requirements.txt`. PowerShell handles Outlook COM, Task Scheduler, and file I/O.

## Memory Architecture

The assistant uses a 4-layer memory model. All reads and writes go through `.agents/skills/memory/memory.py` — no other skill accesses memory files directly. This abstraction allows migrating to a database backend by changing only the memory service.

| Layer | Files | Updated |
|-------|-------|---------|
| 1 — Permanent | `user.profile.md` | Onboarding + explicit changes |
| 2 — Compressed | `projects/CODE/context.md`, `memory/weekly/` | Weekly + on sprint close |
| 3 — Recent | `projects/CODE/logs/`, `reminders.json`, `priorities.json` | Daily / on-demand |
| 4 — Session | `memory/last-session.md` (auto-archived to `memory/sessions/`) | End of each session |

Backend is configured via `MEMORY_BACKEND` env var (default: `file`). Future options: `sqlite`, `postgresql`, `mongodb`, `vector`.

## Skill Registry

`skill-registry.json` at the project root is the inventory of all skills. Updated automatically by `/new-skill` every time a new capability is created.

## Agent Design Principles

Scripts accept params and output JSON (`@{} | ConvertTo-Json` in PS, `json.dumps()` in Python). Read credentials from `.env` or `project.settings` at runtime — never hardcode. ADO commands use MCP tools directly (no local scripts). `skill-registry.json` tracks all skills and is updated by `/new-skill`. Per-project ADO config in `project.settings`; global automations in `automations.json`.

## User Context

The user (Harol) is a TDM and PM at Arroyo Consulting (harol.manchola@arroyoconsulting.net). Communications should be professional but direct — match the tone of a senior technical delivery manager. ADO queries default to the current sprint unless otherwise specified.

## Response Style

Be concise: bullets over paragraphs, results first, no filler phrases or pleasantries. For exports (status reports, emails, stakeholder updates), use full professional prose.

