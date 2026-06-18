# TDM Assistant — Prompt Library

> 77 real-world prompts you can use with `/tdm`, `/ai-architect`, `/sw-architect`, and `/prompt-help` across your first three months.
> All inputs are natural language — no syntax to memorize.
> Copy them as-is or adapt them to your context.

---

## How to use this

Type any of these directly in Claude Code as part of the `/tdm` command, or just paste them in your conversation with the assistant. The assistant routes them to the right skill automatically.

```
/tdm What's on my plate today?
/tdm How is ALPHA doing?
/tdm Draft a status update for the ALPHA executives — we're behind by one sprint
```

---

## 1. Starting Your Day

*Use these every morning to get situational awareness before your first meeting.*

---

**#1 — Standard morning brief**
```
What's on my plate today?
```
> Delivers: full briefing — agenda, urgent emails, project statuses, reminders, priorities.

---

**#2 — Short brief when time is tight**
```
Quick brief — I have a meeting in 15 minutes
```
> Delivers: condensed view — next meeting, any critical emails, top reminder. No project deep-dives.

---

**#3 — Catch-up after an absence**
```
Catch me up — I was out sick for two days. What did I miss?
```
> Reads: session memory, project logs, inbox, calendar changes. Delivers a prioritized "here's what happened" summary.

---

**#4 — Week kickoff on Monday**
```
Start of the week — what does this week look like across all my projects?
```
> Reads: weekly synthesis, project contexts, calendar for the week. Surfaces deadlines, sprint end dates, and meetings that need prep.

---

**#5 — End-of-day wrap-up**
```
Wrap up the day — what did we accomplish and what's pending for tomorrow?
```
> Summarizes session activity, logs it to memory, identifies follow-ups for the next session.

---

## 2. Email

*Handles inbox triage, drafting, replying, and follow-ups.*

---

**#6 — Inbox triage**
```
Review my inbox and tell me what needs my attention today
```
> Filters noise, surfaces urgent emails from key contacts, flags unanswered threads.

---

**#7 — Find a specific thread**
```
Find emails from Sarah about the deployment timeline this week
```
> Searches by sender, topic, and date range.

---

**#8 — Draft a reply you've been avoiding**
```
I haven't replied to John's email from Monday about the budget report. Draft a response saying I'll have the numbers to him by Friday EOD.
```
> Finds the original email, drafts a reply in the right tone, sends on confirmation.

---

**#9 — Follow up after a meeting**
```
Write a follow-up email to the client summarizing what we agreed in today's sprint review
```
> Reads meeting notes or your description, drafts a professional follow-up. Always in English.

---

**#10 — Escalate a stalled communication**
```
The vendor hasn't responded to my RFQ in 5 days. Draft a polite but firm follow-up.
```
> Searches for the original email, drafts an escalating follow-up with a clear deadline ask.

---

**#11 — Decline a meeting request gracefully**
```
Decline the invitation to the 2pm architecture review — I have a conflict. Suggest I can review the notes async.
```
> Finds the invitation, drafts a professional decline with an alternative.

---

**#12 — Announce a change to the team**
```
Write an email to the ALPHA team announcing we're moving to two-week sprints starting next month
```
> Drafts a clear, direct internal announcement with the what, when, and why.

---

## 3. Calendar & Meetings

*Schedule, modify, and prepare for meetings.*

---

**#13 — Set up a recurring standup**
```
Create a daily standup for the ALPHA team every weekday at 9am for 30 minutes. Add John, Sarah, and Mike.
```
> Creates a recurring calendar event with invitations.

---

**#14 — Schedule a one-off meeting**
```
Schedule a 1-hour sprint review for ALPHA next Friday at 2pm. Add the client contact from the project settings.
```
> Reads client email from `project.settings`, creates the event.

---

**#15 — Accept a meeting invitation**
```
Accept the invitation to the quarterly business review on the 25th
```
> Finds the invitation in inbox and responds accepted.

---

**#16 — Prepare for an upcoming meeting**
```
I have a sprint planning session with the ALPHA team in 2 hours. Help me prepare.
```
> Reads ADO backlog, sprint velocity, last retrospective notes, and project context. Delivers a preparation brief.

---

**#17 — Reschedule a meeting**
```
I need to move tomorrow's 10am client check-in to Thursday at the same time. Draft the reschedule email.
```
> Drafts a rescheduling request with a clear explanation.

---

**#18 — What's on the calendar this week**
```
Show me all my meetings this week and flag any that don't have preparation materials
```
> Lists calendar events and checks project folders for recent meeting notes/agendas.

---

## 4. Project Health Checks

*Understand what's happening in your projects without reading every log.*

---

**#19 — Quick status on one project**
```
How is ALPHA doing?
```
> Reads project context, recent logs, ADO blockers. Delivers a 5-line verdict with a traffic light.

---

**#20 — Cross-project risk radar**
```
Which of my projects is most at risk right now?
```
> Reads all project contexts, surfaces the one most likely to miss its deadline or have unmitigated risks.

---

**#21 — Will we make the deadline?**
```
Is ALPHA going to make the go-live date?
```
> Uses velocity trend, remaining backlog, and capacity to give a data-backed prediction with confidence level.

---

**#22 — Deep project analysis**
```
Analyze ALPHA thoroughly — I have a steering committee meeting next week and I need to know what I'm walking into
```
> Runs the full Agile Advisor analysis: delivery health, team health, risks, stakeholder alignment, process maturity.

---

**#23 — Project that's been quiet**
```
GAMMA hasn't come up in a while. Give me a catch-up — what's the current state?
```
> Reads the compressed context, last session notes, and recent logs.

---

**#24 — Portfolio view**
```
Give me a one-line status on all my active projects
```
> Lists every active project with a traffic light and one-sentence summary.

---

**#25 — Post-sprint debrief**
```
ALPHA just finished Sprint 12. What happened and what should I tell the client?
```
> Reads sprint data from ADO, meeting notes, and logs. Drafts an executive summary.

---

## 5. Azure DevOps & Sprint Work

*Manage backlogs, sprints, and work items without leaving Claude Code.*

---

**#26 — Sprint status**
```
What's the status of the current sprint in ALPHA? How many points are done vs. remaining?
```
> Queries ADO for sprint progress, velocity, and at-risk items.

---

**#27 — Backlog health check**
```
Review the ALPHA backlog — how many items are ready to pull into the next sprint?
```
> Checks backlog grooming status: items with acceptance criteria, estimates, and priority.

---

**#28 — Identify blockers**
```
What are the active blockers in BETA and who owns them?
```
> Queries ADO for blocked items, owner, and how long they've been open.

---

**#29 — Create a work item**
```
Create a bug in ALPHA for the issue Sarah reported — the login fails when the username has a period in it. High priority.
```
> Creates the work item in ADO with title, description, type, and priority.

---

**#30 — Velocity and metrics**
```
Show me the velocity trend for BETA over the last 6 sprints and tell me if it's healthy
```
> Queries ADO metrics, generates a velocity chart, and gives a judgment against benchmarks.

---

**#31 — Dependency map**
```
Map all the cross-team dependencies blocking ALPHA right now
```
> Reads ADO dependency tracking and surfaces unresolved inter-team blockers.

---

**#32 — Sprint planning preparation**
```
I'm planning Sprint 13 for ALPHA tomorrow. Pull the candidate items from the backlog and help me size the sprint.
```
> Reads backlog, current capacity, team velocity, and helps build a realistic sprint scope.

---

## 6. Drafting Communications

*Generate any type of professional communication in seconds.*

---

**#33 — Status update to executives**
```
Draft a status update for the ALPHA steering committee — we're one sprint behind and the client is aware
```
> Reads project context, writes an executive summary with status, impact, mitigation, and next steps. Always in English.

---

**#34 — Escalation email**
```
Write an escalation email to my manager about the infrastructure team blocking BETA for 6 days. I need a decision by end of week.
```
> Writes a clear escalation with business impact, timeline, and specific ask.

---

**#35 — Delay notification to a client**
```
I need to tell the ALPHA client we're moving the go-live date back by 2 weeks. They won't be happy. Help me write this.
```
> Reads project context and client details, writes a professional delay notification with reason, revised date, and mitigation actions.

---

**#36 — Sprint review agenda**
```
Create the agenda for ALPHA's Sprint 12 review meeting — 60 minutes, includes demo, metrics review, and retrospective
```
> Drafts a structured meeting agenda with time blocks.

---

**#37 — Stakeholder update**
```
Write a monthly stakeholder update for BETA — budget is on track, delivery is slightly behind, team is healthy
```
> Uses the inputs to write a complete monthly update in the standard format.

---

**#38 — Team announcement**
```
Announce to the ALPHA team that we're implementing a code freeze for the last week of every sprint
```
> Writes a clear, direct internal announcement with context and effective date.

---

**#39 — Meeting notes summary**
```
I just finished a 90-minute discovery session with the new client. Here are my raw notes: [paste notes]. Clean them up and draft a follow-up email.
```
> Structures the notes, extracts decisions and action items, drafts the follow-up.

---

## 7. Risk, Blockers & Escalations

*Proactively manage what can go wrong.*

---

**#40 — Log a new risk**
```
Add a risk to ALPHA: the third-party payment API might deprecate the version we're using in Q4. Probability: medium. Impact: high.
```
> Creates a structured risk entry with scoring and prompts for a mitigation plan.

---

**#41 — Unmitigated risk audit**
```
Which risks across all my projects have no mitigation plan assigned?
```
> Reads risk registers, surfaces unmitigated items sorted by priority score.

---

**#42 — Log a blocker resolution**
```
The database migration blocker in BETA has been resolved — the DBA team fixed it this morning
```
> Updates the ADO item status and logs the resolution in the project log.

---

**#43 — Root cause analysis**
```
ALPHA missed its sprint commitment for the third time in a row. Help me figure out why and what to do about it.
```
> Reads velocity data, logs, and meeting notes. Runs a structured root cause analysis.

---

**#44 — Scope change impact**
```
The client wants to add a real-time notification module to ALPHA. It wasn't in the original scope. Help me analyze the impact.
```
> Estimates effort, assesses schedule and budget impact, drafts a change request document.

---

## 8. Reports & Analytics

*Generate reports and visual data for stakeholders.*

---

**#45 — Weekly status report**
```
Generate the weekly status report for ALPHA — I need to send it to the client by 4pm today
```
> Reads project context, ADO sprint data, recent logs. Drafts the full status report and offers to send by email.

---

**#46 — Excel report for a stakeholder meeting**
```
Create an Excel status report for BETA for the steering committee meeting on Thursday
```
> Generates a formatted Excel file with Summary, Sprint Velocity, Risk Register, and Action Items sheets.

---

**#47 — EVM budget check**
```
Run the EVM analysis for ALPHA — budget is $200k, we're 45% complete, actual spend is $98k, planned was 50% at this point
```
> Calculates CPI, SPI, EAC, VAC. Generates a chart and tells you if the project is financially healthy.

---

**#48 — Velocity chart**
```
Generate a velocity chart for BETA using the last 6 sprints
```
> Queries ADO for sprint data, generates a PNG velocity + commitment ratio chart saved to the project reports folder.

---

**#49 — End-of-sprint metrics**
```
Sprint 12 just closed for ALPHA. Give me the key metrics to share in the sprint review.
```
> Queries ADO for completed vs. committed work, cycle time, and spillover. Delivers a metrics summary.

---

## 9. Memory, Priorities & System

*Manage your context and evolve the assistant over time.*

---

**#50 — Set weekly priorities**
```
My top priorities this week are: close Sprint 12 for ALPHA, finalize the BETA proposal by Wednesday, and review the Q3 budget numbers before the Friday call
```
> Saves these to `priorities.json`. The assistant will reference them in every morning briefing.

---

**#51 — Search your history**
```
Search my memory for anything about the vendor contract negotiations in ALPHA
```
> Searches across session history, project logs, and meeting notes for matching context.

---

**#52 — Compress a project's history**
```
ALPHA has 3 months of logs. Compress it into a current context summary.
```
> Reads all logs, meetings, and decisions. Synthesizes them into a compact `context.md` that loads fast at startup.

---

**#53 — Build a new skill on demand**
```
I need a script that downloads all email attachments from a specific sender this week and saves them to the ALPHA project folder
```
> The skill builder analyzes the request, writes a PowerShell script following project conventions, tests it, and registers it.

---

**#54 — Configure a scheduled automation**
```
Set up the morning sync automation for ALPHA — run it weekdays at 8am
```
> Enables the automation in `project.settings` and registers it with Windows Task Scheduler.

---

**#55 — Update your profile**
```
Update my profile — I now also manage the GAMMA project and my new client contact is David at Accenture, response SLA is 2 hours
```
> Updates the relevant sections of `user.profile.md`. The assistant will use this context in all future sessions.

---

## 10. Writing Better Prompts with `/prompt-help`

*Use these when you know what you want but don't know how to ask for it — or when a prompt isn't giving you the results you expected.*

---

**#56 — Build a prompt from scratch**
```
/prompt-help write a status report for the ALPHA steering committee
```
> Returns a master prompt with role, context, output format, tone, and length constraints — ready to copy and use.

---

**#57 — Improve a vague prompt**
```
/prompt-help improve "make my email better"
```
> Diagnoses what's missing (no audience, no tone, no length target) and returns a specific, structured replacement.

---

**#58 — Prompt for a complex analysis**
```
/prompt-help I want to ask the assistant to analyze whether my project will make its deadline
```
> Returns an analytical prompt that specifies what data to read, which dimensions to evaluate, what verdict format to use, and what to say when data is insufficient.

---

**#59 — Prompt for a difficult conversation**
```
/prompt-help help me ask the assistant to prepare me for a tough conversation with a client who's unhappy about delays
```
> Returns a prompt that sets the right context, asks for specific preparation materials (talking points, anticipated objections, recommended approach), and specifies the tone.

---

**#60 — Prompt for a recurring task you do weekly**
```
/prompt-help I run a weekly EVM review every Friday — help me write a reusable prompt for it
```
> Builds a parameterized master prompt with clear placeholders you fill in each week, so the output is consistent every time.

---

**#61 — Prompt that keeps producing the wrong length**
```
/prompt-help improve this prompt — it always gives me 10 paragraphs when I need 3 bullets: [your prompt]
```
> Identifies the missing output constraints and adds explicit format + length instructions.

---

**#62 — Prompt for generating a document template**
```
/prompt-help create a prompt for generating a project kickoff agenda for any new project
```
> Builds a reusable prompt with smart placeholders (project name, attendees, duration, key topics) so you can use it for every new project.

---

**#63 — Prompt that needs a specific tone**
```
/prompt-help I need to write a difficult scope change email to a client — the tone needs to be firm but not aggressive
```
> Returns a prompt with explicit tone calibration instructions and constraints that prevent common mistakes (being apologetic, being vague about the ask).

---

**#64 — Prompt for an ADO / technical query**
```
/prompt-help how do I ask the assistant to find all overdue work items assigned to me across all my projects
```
> Returns an ADO-specific prompt with the right entities, filters, and output format for the ADO MCP tools.

---

**#65 — Diagnose why a prompt isn't working**
```
/prompt-help This prompt gives me generic answers every time. Can you fix it?
[paste your current prompt]
```
> Runs a full anti-pattern diagnosis: missing role, weak action verbs, no output format, ambiguous constraints. Returns a rewritten version with an explanation of every change.

---

## 11. AI & Software Architecture

*Expert consultants that research industry authorities before every technical recommendation.*
*Invoke directly with `/ai-architect` or `/sw-architect`, or let `/tdm` route naturally.*

---

**#66 — Evaluate an existing AI system**
```
/ai-architect evaluate "We have RAG with GPT-4, Pinecone, and LangChain in production — latency is high and answers feel inconsistent"
```
> Diagnoses 7 dimensions: model fit, agentic design, RAG quality, memory, evals, MLOps, governance. Researches current best practices before recommending.

---

**#67 — Design an agentic solution from scratch**
```
/ai-architect design "A support agent that answers tickets by consulting our internal knowledge base and escalates complex cases to a human"
```
> Researches frameworks, proposes architecture with stack, phases, eval plan, and sourced ADR.

---

**#68 — RAG vs. fine-tuning decision**
```
/ai-architect decide "Should we use RAG or fine-tuning for our legal document classification use case?"
```
> Consults authoritative sources, gives a trade-off table, clear recommendation, and full ADR.

---

**#69 — Compare AI frameworks**
```
/ai-architect compare "LangGraph vs AutoGen vs CrewAI for a multi-agent research system"
```
> Looks up current docs for each option, compares on orchestration, state, cost, and production maturity.

---

**#70 — Design an eval plan**
```
/ai-architect evals "Contract classification system on Claude — measure faithfulness, accuracy, and latency"
```
> Designs a 4-level eval plan (unit, integration, behavioral, safety) with metrics, tools, and golden dataset approach.

---

**#71 — Evaluate a software architecture**
```
/sw-architect evaluate "REST API in Node.js with PostgreSQL, 50k active users, p95 latency 800ms and struggling to scale"
```
> Quality attribute analysis (performance, scalability, resilience, security, observability, maintainability). Sourced recommendations.

---

**#72 — Design a new system**
```
/sw-architect design "Multi-tenant SaaS payment platform, 99.9% SLA, PCI-DSS compliance required"
```
> C4 Level 1+2, quality drivers, stack decisions with trade-offs, phased plan, risk register.

---

**#73 — Architecture decision with full ADR**
```
/sw-architect decide "Microservices or modular monolith for our 8-person team in an early-stage B2B SaaS?"
```
> Searches Martin Fowler, Sam Newman, AWS Well-Architected. Clear recommendation + structured ADR.

---

**#74 — Compare API styles**
```
/sw-architect compare "REST vs GraphQL vs gRPC for our internal service API — 10 microservices, teams in 2 locations"
```
> Trade-off matrix sourced from official documentation. Recommendation based on your specific context.

---

**#75 — Threat modeling**
```
/sw-architect security "Fintech app handling user financial data — I need a threat model before going to production"
```
> STRIDE threat model, OWASP Top 10 applied to your stack, prioritized security controls.

---

**#76 — Migration strategy**
```
/sw-architect migrate "Rails monolith we need to extract into microservices without disrupting production"
```
> Recommends Strangler Fig or appropriate pattern, identifies the best bounded context to start with, incremental roadmap.

---

**#77 — Tech debt audit**
```
/sw-architect debt "Audit our current architecture and prioritize what to fix first before we scale"
```
> Severity-scored debt table with estimated effort, business impact, and remediation roadmap.

---

## Quick reference — intents by category

| If you want to... | Command | Say something like... |
|-------------------|---------|----------------------|
| Start your day | `/tdm` | "What's on my plate today?" |
| Get a project status | `/tdm` | "How is [PROJECT] doing?" |
| Find out what's at risk | `/tdm` | "Which of my projects is most at risk?" |
| Draft any communication | `/tdm` or `/quick-draft` | "Draft a [type] for [audience] about [topic]" |
| Handle your inbox | `/tdm` or `/email-triage` | "Review my inbox and tell me what needs attention" |
| Schedule something | `/tdm` or `/calendar-manage` | "Set up a [meeting type] with [people] on [when]" |
| Log activity | `/tdm` or `/project-agent` | "Log that we completed the integration work in BETA today" |
| Set a reminder | `/remind` | "Remind me to [action] on [date/time]" |
| Set priorities | `/priorities` | "My priorities this week are: [list]" |
| Analyze a project deeply | `/agile-advisor` | "Analyze [PROJECT] thoroughly" |
| Generate a report | `/tdm` | "Generate the weekly status report for [PROJECT]" |
| Add a new capability | `/new-skill` | "I need a skill that does [description]" |
| Catch up after absence | `/tdm` | "Catch me up — I was out for [N] days" |
| Check memory state | `/memory` | "Show me the memory status" |
| Write a better prompt | `/prompt-help` | "Help me write a prompt for [task]" |
| Fix a prompt that isn't working | `/prompt-help` | "Improve this prompt: [paste it]" |
| Evaluate an AI system | `/ai-architect evaluate` | "Our RAG pipeline is slow and inconsistent" |
| Design an agentic solution | `/ai-architect design` | "I need an agent that does [description]" |
| Decide RAG vs fine-tuning | `/ai-architect decide` | "Should we use RAG or fine-tuning for [use case]?" |
| Evaluate a software architecture | `/sw-architect evaluate` | "Our API is struggling to scale — diagnose it" |
| Generate an ADR | `/sw-architect decide` or `/sw-architect adr` | "We chose [technology] — document the decision" |
| Threat model a system | `/sw-architect security` | "Run a threat model on our [system]" |
| Plan a migration | `/sw-architect migrate` | "Help us move from monolith to microservices" |

---

> **Tip:** You don't need to use the command prefix every time.
> In an active session, just type naturally — the assistant maintains context and routes automatically.
>
> **Tip:** Use `/prompt-help` whenever you feel like the assistant is giving you generic or incomplete answers.
> A better-structured prompt is almost always the fix.
