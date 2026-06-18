# staffing-plan

Expert squad composition designer. Given a project scope and architecture, recommends the ideal team structure: roles, seniority ratios, FTE, onboarding timeline, real capacity, and cost estimate. Output is ready to include directly in a proposal.

## Usage

```
/staffing-plan <project name or scope description>    # Design squad from scratch
/staffing-plan optimize CODE                           # Audit and optimize existing team
/staffing-plan backfill CODE <role>                    # Plan replacement for a departing member
/staffing-plan capacity CODE                           # Calculate real sprint capacity for current squad
```

## Behavior

1. Load `.agents/skills/staffing-plan/SKILL.md` — follow the 7-step framework exactly

2. Identify the mode from the command:
   - No subcommand / new project → design squad from scratch
   - `optimize` → audit existing squad for gaps, overlaps, seniority imbalance
   - `backfill` → plan replacement: skills needed, onboarding timeline, interim coverage
   - `capacity` → calculate real sprint capacity with 0.68 effectiveness factor

3. Gather required inputs (ask if not available):
   - Project scope and type
   - Tech stack (frontend, backend, cloud, data)
   - Duration and key milestones (MVP date, full release)
   - Client participation model (embedded PO / weekly reviews / hands-off)
   - Budget constraints (if any)
   - Geographic distribution

4. If project context exists, load it:
   ```
   python .agents/skills/memory/memory.py --op read --type project-context --project CODE
   ```

5. Apply the squad design framework:
   - Select roles from the catalog based on scope and stack
   - Apply seniority ratio matrix for project complexity
   - Design onboarding timeline (Week 1 TDM+TL, Week 2 Seniors, Week 3 full squad)
   - Calculate capacity per sprint with 0.68 effectiveness factor
   - Estimate cost using Latam market ranges (flag to adjust with actual rates)
   - Identify staffing risks (scarce profiles, seniority imbalance, single points of failure)

6. Flag squad design anti-patterns:
   - >10 people for projects < 6 months
   - No dedicated QA in production projects
   - TDM doing code because "we're short-staffed"
   - >50% juniors without sufficient mentoring capacity

## Output format

```
# Staffing Plan — [Project Name]
Type: [project type]  |  Duration: [N months]  |  Phase: [MVP / Full]

## Squad Composition
| Role          | Seniority | FTE | Entry Week | Required Skills          |
|---------------|-----------|-----|------------|--------------------------|
| TDM           | Senior    | 1.0 | Week 1     | Delivery, stakeholders   |
| Tech Lead     | Senior    | 1.0 | Week 1     | [stack], architecture    |
| Backend Dev   | Senior    | 1.0 | Week 2     | [specific stack]         |
| Backend Dev   | Mid       | 1.0 | Week 3     | [specific stack]         |
| QA Engineer   | Mid       | 0.5 | Week 3     | [testing stack]          |
| DevOps        | Mid       | 0.5 | Week 1-2   | [cloud, CI/CD]           |

Total: [N] people | [M] FTE

## Onboarding Timeline
Week 1: TDM + Tech Lead + DevOps (technical setup)
Week 2: Senior devs (architecture + first tasks)
Week 3: Full squad (Sprint 1 with real capacity)

## Sprint Capacity
| Sprint   | Active | Nominal | Effective (~68%) |
|----------|--------|---------|-----------------|
| Sprint 1 | [N]    | [X]h    | [Y]h            |
| Sprint 2+| [N]    | [X]h    | [Y]h            |

## Cost Estimate
| Role      | FTE | Monthly Rate | Monthly Cost |
|-----------|-----|-------------|-------------|
| TDM       | 1.0 | $X          | $Y          |
| ...       |     |             |             |
| **TOTAL** |     |             | **$Z/month**|

Project total ([N] months): $X - $Y USD

## Staffing Risks
| Risk | Impact | Mitigation |
|------|--------|-----------|
```

## Notes

- Rate ranges are Latam market reference — always adjust with client's actual rate card
- Capacity factor 0.68 accounts for meetings, code review, admin, and normal attrition
- For fixed-price proposals, use the conservative squad size (risk buffer)
- Never plan a squad where TDM also codes — it creates a delivery single point of failure
