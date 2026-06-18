# ado-roadmap

Generate a multi-team delivery roadmap from ADO Features and Epics with milestone tracking.

## Usage

```
/ado-roadmap [horizon: quarter | half-year | year] [level: feature | epic]
```

## Behavior

1. Pull all Features (or Epics) from ADO with their iteration assignments and completion status
2. Group by team and time period to build a roadmap view
3. Highlight:
   - Features at risk (not started with < 2 sprints remaining in iteration)
   - Milestones with no associated features
   - Gaps in the roadmap (periods with no committed features)
4. Show cross-team coordination points (shared features or dependencies)
5. Output a text-based Gantt-style roadmap

## Output format

```
# Delivery Roadmap — [Horizon]
**Level:** Feature  |  **Generated:** [today]

## Q[X] [Year]
### Sprint [N] ([dates])
| Team | Feature # | Title | State | % Done | Risk |
|------|-----------|-------|-------|--------|------|

### Sprint [N+1] ([dates])
| ...

## Key Milestones
| Milestone | Target Date | Features Linked | Status |
|-----------|-------------|-----------------|--------|

## At-Risk Items
| Feature # | Title | Team | Reason | Recommended Action |
|-----------|-------|------|--------|--------------------|

## Roadmap Gaps
- [Team]: no committed features in Sprint [N]
```

## Notes

- Uses $ADO_ORG, $ADO_PROJECT env vars
- Default horizon = current quarter
- "At risk" = feature not started with ≤ 2 sprints left in its target iteration
- Suitable for leadership review or client-facing delivery updates
