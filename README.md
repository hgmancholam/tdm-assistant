# PersonalAssistant

A Claude Code-powered personal assistant for Technical Delivery Managers and Project Managers. Operates as an autonomous, proactive agent — your Jarvis — with full visibility into email, calendar, projects, and Azure DevOps. Speaks to you in natural language and orchestrates a growing library of skills to handle the daily load of a TDM.

> **Built on:** Claude Code · PowerShell (Outlook COM) · Python (analytics) · Azure DevOps MCP · Windows Task Scheduler

---

## What it does

| Area | Capabilities |
|------|-------------|
| **Assistant** | Morning briefing, proactive alerts, priority tracking, reminders, smart drafts |
| **Email** | Inbox triage, search, send, reply, move — all via Outlook Desktop COM |
| **Calendar** | View agenda, create events, recurring meetings, accept/decline invitations |
| **Projects** | Per-project workspace: logs, meeting notes, risks, decisions, reports |
| **Azure DevOps** | Sprint planning, backlog grooming, metrics, board audit, dependency tracking |
| **PM** | Status reports, risk register, EVM budget review, retrospectives, scope changes |
| **Analytics** | Velocity charts, EVM calculations, Excel status reports (Python) |
| **Self-evolution** | `/new-skill` creates new PowerShell or Python skills on demand |

---

## Prerequisites

| Requirement | Version / Notes |
|------------|----------------|
| [Claude Code](https://claude.ai/code) | Latest — CLI installed and authenticated |
| Windows | 10 or 11 — required for Outlook COM automation |
| Microsoft Outlook | Desktop app, open and signed in |
| PowerShell | 7+ (`pwsh`) |
| Python | 3.11+ (for analytics scripts) |
| Azure DevOps MCP | Configured in Claude Code settings (for ADO commands) |

---

## Setup

### 1. Clone and configure environment

```powershell
git clone <repo-url>
cd PersonalAssistant

# Copy the env template and fill in your values
Copy-Item .env.example .env
```

Edit `.env`:

```env
ASSISTANT_NAME=Friday        # Name your assistant
USER_NICKNAME=Harol          # How the assistant addresses you
MEMORY_BACKEND=file          # Storage backend (file | sqlite | postgresql)
ANTHROPIC_API_KEY=sk-ant-... # Optional: for runner_api.py automations
```

### 2. Install Python dependencies

```powershell
pip install -r .agents/skills/analytics/requirements.txt
```

### 3. Open Claude Code in this directory

```powershell
claude
```

### 4. First run — onboarding

```
/tdm
```

On first run, the assistant detects there is no user profile and starts an onboarding conversation. It will ask about your role, preferences, key contacts, and alert rules, then write `user.profile.md`. This takes about 5 minutes and only happens once.

---

## Quick start

```
/tdm                        # Morning briefing — agenda, emails, projects, reminders
/tdm how is ALPHA doing?    # Natural language — routes to the right skill
/tdm remind me to call Sarah tomorrow at 10am
/tdm draft a status update for the ALPHA client
/tdm what should I focus on right now?
```

---

## Command reference

### TDM Assistant

| Command | What it does |
|---------|-------------|
| `/tdm [anything]` | Main entry point — natural language routing to all skills |
| `/brief` | Full morning briefing: agenda + emails + projects + reminders + priorities |
| `/quick-draft [context]` | Draft any communication — email, escalation, status update, follow-up |
| `/priorities` | View and manage your current top-5 priorities |
| `/remind [text] [when]` | Create a reminder (persisted across sessions) |
| `/memory status` | Inspect what the assistant knows — memory layers health check |
| `/memory sync-context [CODE\|all]` | Compress project logs into a `context.md` summary |
| `/memory weekly` | Generate this week's synthesis across all projects |

### Email & Calendar

| Command | What it does |
|---------|-------------|
| `/email-triage` | Inbox review with urgency classification |
| `/email-search [query]` | Search by keyword, sender, or subject |
| `/email-send` | Draft and send an email |
| `/email-reply` | Find, draft, and send a reply |
| `/email-move` | Move email to folder |
| `/agenda [days]` | Calendar briefing with meeting prep |
| `/calendar-manage create [details]` | Create a one-time or recurring event |
| `/calendar-manage respond [accept\|decline\|tentative]` | Respond to a meeting invitation |
| `/contacts [query]` | Search and manage Outlook contacts |

### Projects

| Command | What it does |
|---------|-------------|
| `/projects` | List all active projects with status |
| `/new-project` | Create a new project workspace from template |
| `/project-agent CODE [task]` | Manage a project — logs, notes, reports, sync |
| `/projects-digest` | Consolidated daily summary of all active projects |
| `/automate [action] [CODE]` | Manage scheduled automations via Task Scheduler |

### Azure DevOps

| Command | What it does |
|---------|-------------|
| `/ado-sprint-plan CODE` | Sprint planning, review, and close |
| `/ado-backlog CODE` | Backlog review and grooming |
| `/ado-board CODE` | Kanban board audit and WIP analysis |
| `/ado-dashboard CODE` | Text dashboard: burndown, velocity, flow metrics |
| `/ado-work-item` | Create, update, and triage work items |
| `/ado-dependencies CODE` | Dependency map and blocker tracking |
| `/ado-metrics CODE` | Velocity, cycle time, lead time reports |
| `/ado-query [natural language]` | Convert plain English to WIQL queries |

### Project Management

| Command | What it does |
|---------|-------------|
| `/agile-advisor CODE [focus]` | Expert agile + TDM analysis across 6 dimensions |
| `/status-report CODE` | Weekly/monthly status report |
| `/risk-register CODE` | Risk identification, scoring, and mitigation |
| `/budget-review CODE` | EVM analysis: CPI, SPI, EAC, VAC |
| `/decision-log CODE` | Document decisions with context and rationale |
| `/retrospective CODE` | Agile retrospective facilitation |
| `/scope-change CODE` | Change request with impact analysis |
| `/problem-solve` | Root cause analysis and action plan |

### Self-Evolution

| Command | What it does |
|---------|-------------|
| `/new-skill [description]` | Create a new skill on demand — writes the script, tests it, registers it |
| `/new-skill extend [name] — [what to add]` | Extend an existing skill |

---

## Architecture

```
.claude/
  commands/               ← Slash commands (Markdown files)
  settings.json           ← Permissions whitelist for script execution

.agents/skills/
  tdm-assistant/          ← Main agent brain (SKILL.md)
  memory/                 ← Memory service — single abstraction for all storage
  outlook/                ← Outlook Desktop COM scripts (PowerShell → JSON)
  projects/               ← Project data I/O scripts (PowerShell → JSON)
  analytics/              ← Python: charts, EVM, Excel reports
  agile-advisor/          ← Agile Coach + TDM analysis framework
  skill-builder/          ← Meta-skill: creates new skills on demand
  runner.ps1              ← Task Scheduler runner (CLI-based)
  scheduler.ps1           ← Registers/lists/removes scheduled tasks

projects/
  _template/              ← Template for new projects
  <PROJECT-CODE>/
    project.settings      ← Config: ADO org/project/PAT, team, stakeholders
    context.md            ← Compressed project state (auto-generated weekly)
    logs/                 ← Daily activity logs (YYYY-MM-DD.md)
    meetings/             ← Meeting notes
    decisions/            ← Decision log
    risks/                ← Risk register
    reports/              ← Generated reports (Excel, PNG charts)

memory/
  last-session.md         ← What was discussed in the last TDM session
  sessions/               ← Archived session files
  weekly/                 ← Weekly syntheses (weekly-YYYY-WW.md)

user.profile.md           ← User identity, preferences, contacts (built via onboarding)
reminders.json            ← Active reminders
priorities.json           ← Current top priorities
skill-registry.json       ← Inventory of all skills (auto-updated by /new-skill)
automations.json          ← Global scheduled automations
```

---

## Memory system

The assistant builds context over time through 4 layers, all accessed via a single service (`memory.py`):

```
Layer 1 — Permanent     user.profile.md
                         Your identity, preferences, contacts, alert rules.
                         Set during onboarding. Update anytime with /tdm update profile

Layer 2 — Compressed    projects/CODE/context.md
                         Weekly synthesis of a project's state: sprint status,
                         open risks, key decisions. Replaces reading 60+ raw logs.
                         Update with: /memory sync-context CODE

                         memory/weekly/weekly-YYYY-WW.md
                         Cross-project weekly synthesis. Run every Friday.
                         Update with: /memory weekly

Layer 3 — Recent        projects/CODE/logs/YYYY-MM-DD.md
                         Raw daily activity. The assistant reads only the last 3-7 days.
                         reminders.json / priorities.json — current operational state.

Layer 4 — Session       memory/last-session.md
                         What was discussed in the previous session: actions taken,
                         follow-ups, context to resume from. Auto-archived after each session.
```

**Startup reading strategy:** Layer 1 (always) + Layer 2 (always) + Layer 4 (always) + Layer 3 last 3-5 days only.

### Future-proof storage

The memory service is an abstraction layer. The backend is configured via `MEMORY_BACKEND` in `.env`:

| Value | Backend | Status |
|-------|---------|--------|
| `file` | Local Markdown + JSON files | ✅ Active |
| `sqlite` | SQLite local database | Planned |
| `postgresql` | PostgreSQL | Planned |
| `vector` | Vector database (semantic search) | Planned |

To migrate: implement the new backend class in `memory.py`, register it, set the env var. Zero changes elsewhere.

---

## Outlook integration

Email, calendar, and contacts use **Windows COM Automation** — no Azure app registration, no OAuth flow, no IT permissions required. Outlook Desktop must be open and signed in.

```powershell
# All scripts accept parameters and output JSON
pwsh -File ".agents/skills/outlook/get-inbox.ps1" -Count 20 -UnreadOnly
pwsh -File ".agents/skills/outlook/send-email.ps1" -To "name@company.com" -Subject "..." -Body "..."
pwsh -File ".agents/skills/outlook/create-event.ps1" -Subject "Sprint Review" -StartTime "2026-06-20 14:00" -EndTime "2026-06-20 15:00"
```

---

## Azure DevOps integration

ADO is accessed via the **ADO MCP server** (`mcp__ado__*` tools) — no local scripts needed. Each project stores its own credentials in `project.settings` to prevent cross-project errors:

```json
{
  "ado": {
    "org":      "my-organization",
    "project":  "ProjectName",
    "pat":      "your-personal-access-token",
    "areaPath": "ProjectName\\TeamName",
    "teamName": "TeamName"
  }
}
```

Generate a PAT at `https://dev.azure.com/<org>/_usersSettings/tokens` with scopes: Work Items (Read & Write), Code (Read), Build (Read).

---

## Per-project setup

```
/new-project
```

This creates a workspace under `projects/<CODE>/` with all required folders and a `project.settings` file. Fill in the settings file with your project details, ADO configuration, team, stakeholders, and communication preferences.

To enable scheduled automations for a project:

```
/automate register CODE
```

---

## Extending the system

The assistant grows with you. To add a new capability:

```
/new-skill a script that downloads all attachments from a specific email thread and saves them to the project folder
```

The skill builder will:
1. Verify no existing skill already covers it
2. Decide the right technology (PowerShell for Windows/Outlook, Python for data/APIs)
3. Write the script following established conventions (params, JSON output, try/catch)
4. Test it
5. Register it in `skill-registry.json` and `CLAUDE.md`

---

## Scheduled automations

The assistant can run tasks automatically via Windows Task Scheduler:

```
/automate register-all     # Register all enabled automations
/automate list             # See all registered tasks
/automate run CODE morning-sync   # Test a task immediately
```

Default automations per project (configured in `project.settings`):
- `morning-sync` — 8:00 AM weekdays
- `weekly-report` — Friday 5:00 PM
- `end-of-day` — 6:00 PM weekdays

Global automations (`automations.json`):
- `daily-digest` — 7:00 AM weekdays (all projects)

---

## Tech stack

| Component | Technology |
|-----------|-----------|
| AI agent | Claude Code (Anthropic) |
| Windows automation | PowerShell 7+ with Outlook COM |
| Data analysis | Python 3.11+ (pandas, matplotlib, openpyxl) |
| ADO integration | ADO MCP server |
| Scheduling | Windows Task Scheduler |
| Memory storage | Local files (Markdown + JSON) — pluggable backend |
| Advanced automations | Anthropic Python SDK (`runner_api.py`) |

---

## Project structure reference

```
skill-registry.json    Inventory of all skills — updated by /new-skill
user.profile.md        Your profile — built via /tdm onboarding
reminders.json         Active reminders — managed by /remind
priorities.json        Current priorities — managed by /priorities
automations.json       Global automation schedule
.env                   Environment variables (not committed)
.env.example           Template for .env
```

---

## Documentation

Additional setup guides are in `docs/`:
- `outlook-com-setup.md` — Outlook COM automation setup and troubleshooting
