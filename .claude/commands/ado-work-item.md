# ado-work-item

Create, update, triage, or bulk-manage Azure DevOps work items.

## Usage

```
/ado-work-item <action: create | update | triage | bulk-update> [context or item details]
```

## Behavior

### create
- Prompt for: title, type (Epic/Feature/Story/Bug/Task), description, acceptance criteria, area path, iteration, assignee, story points
- Generate a well-formed work item and create it via ADO API
- Return the created item ID and URL

### update
- Accept item ID and fields to change
- Apply the update and confirm

### triage
- Pull all New/Proposed items not yet assigned or estimated
- For each: suggest priority, assignee, and story point estimate based on title/description
- Output a triage table ready for team review

### bulk-update
- Accept a list of IDs and a shared field change (e.g., move to next sprint, change state to Closed)
- Apply changes and report results

## Output format

**create/update:**
```
✅ Work Item Created/Updated
ID: #XXXX  |  Type: Story  |  State: New
Title: [title]
URL: https://dev.azure.com/{org}/{project}/_workitems/edit/XXXX
```

**triage:**
```
# Triage Queue — [Date]
| ID | Title | Suggested Type | Priority | Est. Points | Suggested Assignee |
|----|-------|----------------|----------|-------------|-------------------|
```

## Notes

- Uses $ADO_ORG, $ADO_PROJECT, $ADO_PAT env vars
- Always set Area Path and Iteration when creating items — orphaned items create backlog noise
- Bug work items: always include repro steps in description
- Tone: precise — field values should be specific, not generic placeholders
