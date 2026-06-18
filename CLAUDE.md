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

The primary agent is `/tdm` — the user's personal Jarvis. It:

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

## Slash Commands (`.claude/commands/`)

Commands are Markdown files that Claude Code loads as `/command-name`.

### TDM Assistant
| Command | Purpose |
|---------|---------|
| `/tdm` | Main entry point — natural language, routes to all skills |
| `/brief` | Morning briefing: agenda + emails + projects + reminders + priorities |
| `/quick-draft` | Draft any communication (email, update, escalation, follow-up) |
| `/priorities` | View and manage current top priorities |
| `/remind` | Create and manage personal reminders |

### Email & Calendar
| Command | Purpose |
|---------|---------|
| `/email-triage` | Inbox review with urgency classification |
| `/email-search` | Search emails by keyword, sender, or subject |
| `/email-send` | Draft and send an email |
| `/email-reply` | Find, draft, and send a reply |
| `/email-move` | Move an email to a folder |
| `/agenda` | Daily/weekly calendar briefing with meeting prep |
| `/calendar-manage` | Create events, recurring meetings, respond to invitations |
| `/contacts` | Search, view, and manage Outlook contacts |

### Projects
| Command | Purpose |
|---------|---------|
| `/projects` | List all projects with status |
| `/new-project` | Create a new project workspace |
| `/project-agent CODE task` | Project data agent — logs, notes, reports, syncs |
| `/projects-digest` | Daily consolidated summary of all active projects |
| `/automate <action> [CODE]` | Manage periodic automations via Windows Task Scheduler |

### Azure DevOps
| Command | Purpose |
|---------|---------|
| `/ado-backlog` | Backlog review and grooming |
| `/ado-sprint-plan` | Sprint planning, review, and close |
| `/ado-board` | Kanban board audit and WIP analysis |
| `/ado-dashboard` | Text dashboard: burndown, velocity, metrics |
| `/ado-work-item` | Create, update, triage work items |
| `/ado-dependencies` | Dependency map and blocker tracking |
| `/ado-roadmap` | Multi-team delivery roadmap |
| `/ado-metrics` | Velocity, cycle time, lead time, flow metrics |
| `/ado-team-setup` | Team and iteration path configuration audit |
| `/ado-query` | Natural language → WIQL queries |

### Project Management
| Command | Purpose |
|---------|---------|
| `/project-plan` | Generate project plan with WBS and milestones |
| `/status-report` | Weekly/monthly status report |
| `/risk-register` | Risk identification and prioritization |
| `/budget-review` | EVM budget analysis |
| `/time-estimate` | Three-point estimation |
| `/stakeholder-update` | Draft stakeholder communications |
| `/problem-solve` | Root cause analysis and action plan |
| `/retrospective` | Agile retrospective facilitation |
| `/scope-change` | Change request with impact analysis |
| `/decision-log` | Document decisions with context and rationale |

### Analysis
| Command | Purpose |
|---------|---------|
| `/agile-advisor CODE` | Expert agile/TDM analysis of a project |
| `/ai-architect [action] [topic]` | AI & agentic architecture expert — evaluate, design, decide, compare, evals, security |
| `/sw-architect [action] [topic]` | Software architecture expert — evaluate, design, ADR, debt, security, migrate |

### Self-Evolution
| Command | Purpose |
|---------|---------|
| `/new-skill [description]` | Create a new skill on demand — PowerShell, Python, or command |

## Python Analytics (`.agents/skills/analytics/`)

Python is used for tasks where it clearly wins over PowerShell: data analysis, charts, Excel/PDF generation, and programmatic API calls.

| Script | Purpose |
|--------|---------|
| `velocity_chart.py` | Sprint velocity + commitment ratio chart (PNG) |
| `evm_report.py` | EVM metrics (CPI, SPI, EAC, VAC) + chart |
| `excel_report.py` | Full Excel status report (Summary, Sprints, Risks, Actions) |
| `runner_api.py` | Automation runner using Anthropic SDK (alternative to runner.ps1) |

Install dependencies: `pip install -r .agents/skills/analytics/requirements.txt`

PowerShell stays as the tool for: Outlook COM, Windows Task Scheduler, file I/O, and all native Windows automation.

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

- **`.agents/skills/tdm-assistant/`** — Main agent behavior definition (SKILL.md)
- **`.agents/skills/outlook/`** — PowerShell scripts using Outlook COM; each script accepts params and outputs JSON
- **`.agents/skills/projects/`** — PowerShell scripts for project data I/O (logs, notes, settings files)
- **`.agents/skills/analytics/`** — Python scripts for data analysis, charts, Excel reports
- **`.agents/skills/skill-builder/`** — Meta-skill definition for creating new skills on demand
- **`.agents/skills/runner.ps1`** — invoked by Task Scheduler; runs a task via Claude CLI
- **`.agents/skills/runner_api.py`** — alternative runner using Anthropic SDK for richer automations
- **`.agents/skills/scheduler.ps1`** — registers/removes/lists tasks in Windows Task Scheduler
- **ADO commands** — use MCP tools directly (no local scripts needed)
- **`skill-registry.json`** — inventory of all skills; updated by `/new-skill`
- Always read environment variables at runtime; never hardcode credentials
- Per-project ADO config and automations live in `project.settings`; global automations in `automations.json`
- All scripts output JSON; PowerShell uses `@{} | ConvertTo-Json`, Python uses `json.dumps()`

## User Context

The user (Harol) is a TDM and PM at Arroyo Consulting (harol.manchola@arroyoconsulting.net). Communications should be professional but direct — match the tone of a senior technical delivery manager. ADO queries default to the current sprint unless otherwise specified.

