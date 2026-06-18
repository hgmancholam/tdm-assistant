# ado-team-setup

Audit or configure team structure — area paths, iteration paths, and team settings in Azure DevOps.

## Usage

```
/ado-team-setup [action: audit | setup | iterations] [team: <team name>]
```

## Behavior

### audit
- List all teams in the project with their area paths and iteration assignments
- Flag teams with no area path, no iterations defined, or no capacity set
- Identify area path overlaps (multiple teams owning the same area)

### setup
- Guide through creating or updating a team's area path and iteration configuration
- Suggest a standard iteration cadence (2-week sprints, 6 sprints ahead) if not configured
- Output the configuration steps or API calls needed

### iterations
- List all defined iteration paths with start/end dates
- Flag missing future iterations (< 3 sprints defined ahead)
- Suggest iteration naming convention if inconsistent

## Output format

```
# Team Setup Audit — [Project]
**Date:** [today]

## Teams Overview
| Team | Area Path | Iterations Assigned | Capacity Set | Issues |
|------|-----------|---------------------|--------------|--------|
| ...  | ...       | X sprints           | Yes/No       | ⚠️/✅  |

## Configuration Issues
- [Team]: No area path defined — work items will fall to root area
- [Team]: Only X sprint(s) defined — recommend at least 6 ahead

## Iteration Path Summary
| Iteration | Start | End | Teams Assigned |
|-----------|-------|-----|----------------|

## Recommendations
1. ...
```

## Notes

- Uses $ADO_ORG, $ADO_PROJECT env vars
- Standard recommendation: 2-week sprints, 6 iterations defined ahead, capacity set per team member
- Area path overlaps cause reporting ambiguity — always flag these
