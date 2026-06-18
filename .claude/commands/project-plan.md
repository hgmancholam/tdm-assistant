# project-plan

Create or review a project plan with scope, milestones, and WBS for a given initiative.

## Usage

```
/project-plan <project name or description>
```

## Behavior

1. Ask for project name, objective, key deliverables, and deadline if not provided
2. Generate a structured project plan including:
   - Project objective and success criteria
   - Work Breakdown Structure (WBS) with phases and tasks
   - Key milestones with target dates
   - Assumptions and constraints
   - Stakeholders list
3. Format output as a document ready to share or paste into ADO/email

## Output format

```
# Project Plan: [Project Name]

**Objective:** ...
**Owner:** Harol Manchola
**Target Date:** ...

## Milestones
| Milestone | Target Date | Status |
|-----------|-------------|--------|
| ...       | ...         | ...    |

## Work Breakdown Structure
- Phase 1: ...
  - Task 1.1 ...
  - Task 1.2 ...

## Assumptions & Constraints
- ...

## Stakeholders
- ...
```

## Notes

- Default to current sprint context if no deadline is given
- Tone: professional, concise — suitable for a TDM/PM at a consulting firm
- If ADO context is available, suggest linking milestones to work items
