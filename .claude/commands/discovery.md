# discovery

Expert consultive discovery and inception facilitator. Structures ambiguous client problems into clear scope, assumptions, and success criteria — the foundation for estimation, architecture, and proposals.

## Usage

```
/discovery prepare <client or project name>    # Prepare workshop agenda, stakeholder map, question guide
/discovery facilitate <project name>            # Capture workshop notes and generate structured output
/discovery document <project name>              # Generate Discovery Output document from existing info
/discovery review <project name>                # Audit an existing discovery for gaps
```

## Behavior

1. Load `.agents/skills/discovery/SKILL.md` — follow the 4-phase framework exactly

2. Identify the mode from the command:
   - `prepare` → Phase 1: pre-workshop preparation
   - `facilitate` → Phase 2: workshop facilitation + Phase 3: document output
   - `document` → Phase 3: generate Discovery Output document
   - `review` → audit existing discovery for missing sections

3. If project context exists, load it:
   ```
   python .agents/skills/memory/memory.py --op read --type project-context --project CODE
   ```

4. For **prepare** mode:
   - Generate: workshop agenda (full 4h or short 90-min version)
   - Generate: stakeholder mapping template with the 4 key questions
   - Generate: question guide for all 5 blocks

5. For **facilitate** / **document** mode:
   - Ask the user for information block by block (Problem → Users → Solution → Scope → Risks)
   - Or process raw notes if the user pastes them
   - Generate the full Discovery Output document

6. For **review** mode:
   - Check for: Problem Statement (1 clear sentence), In-Scope list, Out-of-Scope list,
     Assumptions with consequences, Dependencies, Success criteria (measurable)
   - Flag missing or weak sections

7. At the end of a facilitate/document session, prompt the next steps:
   ```
   → Architecture: /sw-architect — validate the proposed solution and tech constraints
   → Estimation: /hours-estimator — estimate effort based on In-Scope items
   → Staffing: /staffing-plan — design the squad for this scope
   → Proposal: /proposal — generate the full SOW
   ```

8. Save discovery output to project folder if a project code is specified:
   ```
   python .agents/skills/memory/memory.py --op append --type log \
     --project CODE --entry "Discovery completed — scope defined, [N] In-Scope items"
   ```

## Output format

```
# Discovery Output — [Project Name]
Client: [name]  |  Date: [date]  |  Facilitator: [TDM name]

## Problem Statement
> [One sentence]

## Impacto Cuantificado
- [Metric 1]: [current] → target: [desired]

## In-Scope ✅
1. [specific item]
2. [specific item]

## Out-of-Scope ❌
1. [item — reason]

## Critical Assumptions
| # | Assumption | Impact if wrong |
|---|-----------|----------------|

## Risks Identified
| # | Risk | Prob | Impact | Mitigation |
|---|------|------|--------|-----------|

## Next Steps
| Action | Owner | By |
|--------|-------|----|
```

## Notes

- Always push for quantified problem statements — "it's important" is not a problem statement
- Always document Out-of-Scope explicitly — this is the main defense against scope creep
- Each assumption must have its consequence if wrong
- Signal alert: MVP with >10 In-Scope items in the first workshop — scope needs more filtering
- Handoff to `/proposal` only after scope is fully defined and signed off
