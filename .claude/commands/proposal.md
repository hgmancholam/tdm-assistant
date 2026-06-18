# proposal

Proposal and Statement of Work (SOW) generator. Orchestrates discovery, architecture, staffing, and estimation outputs into a complete, client-ready proposal document. Covers Executive Summary through commercial terms.

## Usage

```
/proposal new <project name>              # Generate full proposal from scratch
/proposal update <project name> <section> # Update a specific section (scope change, re-estimate)
/proposal review <project name>           # Audit proposal for coherence and completeness
/proposal exec-summary <project name>     # Generate only the Executive Summary
```

## Behavior

1. Load `.agents/skills/proposal/SKILL.md` — follow the template and process exactly

2. Identify the mode from the command:
   - `new` → generate full proposal, gather all inputs
   - `update` → regenerate only the specified section with new data
   - `review` → audit for coherence: does scope match estimate? Does squad fit timeline?
   - `exec-summary` → generate only the Executive Summary block

3. Check for existing inputs (ask what's available before generating):
   - Discovery output (`/discovery` already run?)
   - Effort estimate (`/hours-estimator` already run?)
   - Staffing plan (`/staffing-plan` already run?)
   - Architecture design (`/sw-architect` already run?)

4. If project context exists, load it:
   ```
   python .agents/skills/memory/memory.py --op read --type project-context --project CODE
   ```

5. For sections without input data, mark as:
   `[PENDIENTE: completar con output de /discovery]`
   and tell the user which skill to run.

6. Generate the full proposal following the SOW template:
   - Executive Summary (non-technical, CEO-readable in 90 seconds)
   - Problem Understanding (context + quantified impact + success criteria)
   - Proposed Solution (components + architecture + integrations)
   - Scope (In-Scope ✅ / Out-of-Scope ❌ / Critical Assumptions)
   - Delivery Methodology (ceremonies, cadence, tools)
   - Team (squad from /staffing-plan)
   - Roadmap (phases + milestones with real dates)
   - Effort & Cost (P50/P80/P90 from /hours-estimator)
   - Risk Management (from /risk-register or discovery risks)
   - Commercial Terms (change management process, client commitments)

7. Run the quality checklist before finalizing:
   - Problem Statement is one clear sentence without tech jargon
   - In-Scope items are specific (not "reporting module" but "sales reports filtered by region, period, product")
   - Each assumption has a consequence if wrong
   - Estimate commits to P80, not P50
   - Timeline has real dates, not just "Sprint 1, Sprint 2"
   - Executive Summary stands alone without reading the rest

8. Save to project folder if a project code is specified:
   ```
   python .agents/skills/memory/memory.py --op append --type log \
     --project CODE --entry "Proposal generated — version 1.0, [date]"
   ```

## Output format

Full proposal follows the SOW template in `.agents/skills/proposal/SKILL.md`.

For `exec-summary` mode:
```
# Executive Summary — [Project Name]

[Paragraph 1: the client's business problem in their language, not ours]

[Paragraph 2: the solution and why it's the right one]

[Paragraph 3: business value delivered — quantified]

[Paragraph 4: investment required, timeline, and why we're the right choice]
```

For `review` mode:
```
# Proposal Review — [Project Name]

## Coherence Check
✅/❌ Scope ↔ Estimate: [finding]
✅/❌ Squad ↔ Timeline: [finding]
✅/❌ Architecture ↔ Stack: [finding]

## Missing Sections
- [Section]: [what's needed and which skill to run]

## Quality Issues
- [Issue]: [specific recommendation]

## Ready to send: YES / NO — [reason]
```

## Notes

- The proposal is for the client, not the internal team — language must be executive-level
- Never commit to P50 in a fixed-price engagement — always P80 minimum
- Out-of-Scope is as important as In-Scope — it's the main protection against scope creep
- The Executive Summary must be readable by someone who reads nothing else
- Avoid: "state-of-the-art", "end-to-end solution", "robust platform" — replace with measurable claims
