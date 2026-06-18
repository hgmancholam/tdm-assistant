# PersonalAssistant

A Claude Code-powered personal assistant for Technical Delivery Managers and Project Managers. Operates as an autonomous, proactive agent with full visibility into email, calendar, projects, and Azure DevOps. Understands natural language and orchestrates a growing library of skills to handle the daily load of a TDM.

> **Built on:** Claude Code · PowerShell (Outlook COM) · Python (analytics) · Azure DevOps MCP · Windows Task Scheduler

---

## What it does

| Area | Capabilities |
|------|-------------|
| **Assistant** | Morning briefing, proactive alerts, priority tracking, reminders, smart drafts |
| **Email** | Inbox triage, search, send, reply, move — via Outlook Desktop COM |
| **Calendar** | View agenda, create events, recurring meetings, accept/decline invitations |
| **Projects** | Per-project workspace: logs, meeting notes, risks, decisions, reports, imported docs |
| **Azure DevOps** | Sprint planning, backlog grooming, metrics, board audit, dependency tracking |
| **PM** | Status reports, risk register, EVM budget review, retrospectives, scope changes |
| **Analytics** | Velocity charts, EVM calculations, Excel status reports (Python) |
| **Architecture** | AI architecture decisions, software architecture reviews, ADRs, threat models |
| **Research** | Web search, multi-source research, document Q&A, page fetch |
| **Prompt Engineering** | Write and optimize prompts with the CRATE framework |
| **Token Optimization** | Compressed communication mode (~65% fewer output tokens) via `/caveman` |
| **Self-evolution** | `/new-skill` creates new PowerShell or Python skills on demand |

---

## Prerequisites

| Requirement | Version / Notes |
|------------|----------------|
| [Claude Code](https://claude.ai/code) | Latest — CLI installed and authenticated |
| Windows | 10 or 11 — required for Outlook COM automation |
| Microsoft Outlook | Desktop app, open and signed in |
| PowerShell | 7+ (`pwsh`) |
| Python | 3.8+ (for analytics and memory service) |
| Node.js | 18+ (for caveman skill) |
| Azure DevOps MCP | Configured in Claude Code settings (for ADO commands) |

---

## Setup

### 1. Clone and configure environment

```powershell
git clone <repo-url>
cd PersonalAssistant

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

On first run, the assistant detects there is no user profile and starts an onboarding flow. **Before asking any profile questions, it verifies the full environment:**

| Check | What it verifies |
|-------|-----------------|
| Python 3.8+ | `python --version` |
| pip packages | `pandas`, `matplotlib`, `openpyxl`, `anthropic`, `pdfplumber`, `pypdf`, `python-docx`, `python-pptx` |
| PowerShell 7+ | `pwsh --version` |
| Claude CLI | `claude --version` (recommended — needed for Task Scheduler automations) |
| Outlook Desktop | Runs a test calendar query via COM |

Python, pip packages, PowerShell 7, and Outlook are blocking. Claude CLI is recommended but not required to proceed.

After verification, the assistant walks through 7 groups of questions (identity, role, communication preferences, priorities, key contacts, alerts, automations), then:

- Writes `user.profile.md`
- Configures `automations.json` with your preferred briefing schedule
- Registers tasks in Windows Task Scheduler
- Creates project workspaces for any projects you mention
- Initializes all memory layers

The onboarding takes about 5 minutes and only runs once.

---

## Quick start

```
/tdm                                       # Morning briefing or natural language
/tdm qué tengo hoy
/tdm cómo va el proyecto ALPHA
/tdm responde el email de John sobre el deadline
/tdm recuérdame revisar el contrato mañana a las 10am
/tdm qué debo hacer ahora
```

---

## Command reference

### TDM Assistant

| Command | What it does |
|---------|-------------|
| `/tdm [anything]` | Main entry point — natural language routing to all skills |
| `/tdm setup` | Re-run onboarding (rebuilds profile from scratch) |
| `/tdm update profile — [change]` | Update a section of your profile |
| `/brief` | Full morning briefing: agenda + urgent emails + project status + reminders + priorities |
| `/brief quick` | Briefing without project status |
| `/quick-draft [context]` | Draft any communication — email, escalation, status update, follow-up |
| `/priorities` | View and manage your current top-5 priorities |
| `/remind [text] [when]` | Create a reminder (persisted across sessions) |

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
| `/import-doc CODE --file "path"` | Import PDF, Word, PowerPoint, or Excel into a project folder |
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
| `/ado-roadmap CODE` | Multi-team delivery roadmap |
| `/ado-team-setup CODE` | Team and iteration path configuration audit |
| `/ado-query [natural language]` | Convert plain English to WIQL queries |

### Project Management

| Command | What it does |
|---------|-------------|
| `/status-report CODE` | Weekly/monthly status report |
| `/risk-register CODE` | Risk identification, scoring, and mitigation |
| `/budget-review CODE` | EVM analysis: CPI, SPI, EAC, VAC |
| `/decision-log CODE` | Document decisions with context and rationale |
| `/retrospective CODE` | Agile retrospective facilitation |
| `/scope-change CODE` | Change request with impact analysis |
| `/problem-solve` | Root cause analysis and action plan |
| `/time-estimate` | Three-point estimation |
| `/project-plan CODE` | Generate project plan with WBS and milestones |
| `/stakeholder-update CODE` | Draft stakeholder communications |

### Analysis & Architecture

| Command | What it does |
|---------|-------------|
| `/agile-advisor CODE [focus]` | Expert agile + TDM analysis across 6 dimensions (delivery, team, risks, stakeholders, process, AI-readiness) |
| `/ai-architect [action] [topic]` | AI & agentic architecture — evaluate, design, decide, compare, evals, security |
| `/sw-architect [action] [topic]` | Software architecture — evaluate, design, ADR, debt, security, migrate |
| `/prompt-help [task]` | Write or optimize any prompt using the CRATE framework |

### Research & Intelligence

| Command | What it does |
|---------|-------------|
| `/web-search [query]` | Search the web and return a synthesized answer with sources |
| `/research [topic]` | Multi-angle research with structured briefing across 2-3 sources |
| `/page-fetch [url]` | Fetch and summarize a specific web page |

### Memory

| Command | What it does |
|---------|-------------|
| `/memory status` | Memory layers health check — what the assistant knows |
| `/memory sync-context CODE` | Compress project logs into a `context.md` summary |
| `/memory weekly` | Generate this week's synthesis across all active projects |

### Token Optimization

| Command | What it does |
|---------|-------------|
| `/caveman` | Compressed communication mode (~65% fewer output tokens). Professional emails and exported content always use full prose. |
| `/caveman lite\|full\|ultra` | Switch intensity level |
| `/caveman off` | Return to normal mode |

### Self-Evolution

| Command | What it does |
|---------|-------------|
| `/new-skill [description]` | Create a new skill on demand — writes the script, tests it, registers it |
| `/new-skill extend [name] — [what to add]` | Extend an existing skill |

---

## Architecture

```
.claude/
  commands/               ← Slash commands (Markdown files, one per /command)
  settings.json           ← Permissions whitelist for script execution

.agents/skills/
  tdm-assistant/          ← Main agent brain (SKILL.md) — routing, onboarding, briefing
  memory/                 ← Memory service — single abstraction for all storage (memory.py)
  outlook/                ← Outlook Desktop COM scripts (PowerShell → JSON)
  projects/               ← Project data I/O scripts (PowerShell → JSON)
  analytics/              ← Python: velocity charts, EVM, Excel reports
  agile-advisor/          ← Agile Coach + TDM 6-dimension analysis framework
  ai-architect/           ← AI & agentic architecture expert
  sw-architect/           ← Software architecture expert (ADRs, threat models, migrations)
  prompt-engineer/        ← Prompt optimization with CRATE framework
  caveman/                ← Token optimization: compressed communication mode
  mcp-builder/            ← Guide for building MCP servers (FastMCP / MCP SDK)
  grill-with-docs/        ← Relentless design interview → ADRs and glossary
  writing-plans/          ← Structured planning for complex writing tasks
  subagent-driven-development/ ← Patterns for subagent orchestration
  dispatching-parallel-agents/ ← Parallel agent dispatch patterns
  find-skills/            ← Locate existing skills before creating new ones
  skill-builder/          ← Meta-skill: creates new skills on demand
  skill-creator/          ← Alternative skill creation flow
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
    retrospectives/       ← Sprint retrospectives

memory/
  last-session.md         ← What was discussed in the last session
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
                         Your identity, preferences, key contacts, alert rules.
                         Set during onboarding. Update with: /tdm update profile

Layer 2 — Compressed    projects/CODE/context.md
                         Weekly synthesis: sprint status, open risks, key decisions.
                         Replaces reading 60+ raw logs per project.
                         Update with: /memory sync-context CODE

                         memory/weekly/weekly-YYYY-WW.md
                         Cross-project weekly synthesis. Run every Friday.
                         Update with: /memory weekly

Layer 3 — Recent        projects/CODE/logs/YYYY-MM-DD.md
                         Raw daily activity. Assistant reads last 3-7 days.
                         reminders.json / priorities.json — current operational state.

Layer 4 — Session       memory/last-session.md
                         What was discussed in the previous session: actions taken,
                         follow-ups, context to resume from. Auto-archived each session.
```

**Startup reading order:** Layer 1 (always) → Layer 2 (always) → Layer 4 (always) → Layer 3 last 3–5 days.

The memory service is an abstraction layer. Backend configured via `MEMORY_BACKEND` in `.env`:

| Value | Backend | Status |
|-------|---------|--------|
| `file` | Local Markdown + JSON | Active |
| `sqlite` | SQLite local database | Planned |
| `postgresql` | PostgreSQL | Planned |
| `vector` | Vector database (semantic search) | Planned |

---

## Outlook integration

Email, calendar, and contacts use **Windows COM Automation** — no Azure app registration, no OAuth, no IT permissions. Outlook Desktop must be open and signed in.

```powershell
# All scripts accept parameters and output JSON
pwsh -File ".agents/skills/outlook/get-inbox.ps1" -Count 20 -UnreadOnly
pwsh -File ".agents/skills/outlook/send-email.ps1" -To "name@company.com" -Subject "..." -Body "..."
pwsh -File ".agents/skills/outlook/get-calendar.ps1" -Days 7
pwsh -File ".agents/skills/outlook/create-event.ps1" -Subject "Sprint Review" -StartTime "2026-06-20 14:00" -EndTime "2026-06-20 15:00"
```

---

## Azure DevOps integration

ADO is accessed via the **ADO MCP server** (`mcp__ado__*` tools) — no local scripts needed. Each project stores its own credentials in `project.settings`:

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

Creates a workspace under `projects/<CODE>/` with all required folders and a `project.settings` file. Fill in the ADO configuration, team, and stakeholders. To enable scheduled automations:

```
/automate register CODE
```

---

## Document import

Import external documents into a project workspace with structure preservation:

```
/import-doc ALPHA --file "C:\Users\harol\Documents\proposal.docx"
/import-doc ALPHA --file "report.pdf" --category meetings
/import-doc list ALPHA
```

Supported formats: PDF (`.pdf`), Word (`.docx`), PowerPoint (`.pptx`), Excel (`.xlsx`).

---

## Extending the system

```
/new-skill a script that downloads all attachments from a specific email thread and saves them to the project folder
```

The skill builder verifies no existing skill covers it, picks the right technology (PowerShell for Windows/Outlook, Python for data/APIs), writes the script, tests it, and registers it in `skill-registry.json`.

---

## Scheduled automations

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
| Data analysis | Python 3.8+ (pandas, matplotlib, openpyxl) |
| ADO integration | ADO MCP server |
| Scheduling | Windows Task Scheduler |
| Memory storage | Local files (Markdown + JSON) — pluggable backend |
| Token optimization | caveman skill (project-level, Node.js 18+) |
| Advanced automations | Anthropic Python SDK (`runner_api.py`) |

---

## Documentation

Additional setup guides in `docs/`:
- `outlook-com-setup.md` — Outlook COM automation setup and troubleshooting
