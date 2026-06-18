# problem-solve

Run a structured root cause analysis and generate an action plan for a project problem.

## Usage

```
/problem-solve <problem description>
```

## Behavior

1. Restate the problem clearly and confirm scope
2. Apply 5 Whys to identify root cause(s)
3. Generate solution options (at least 3) with trade-offs:
   - Effort (Low / Med / High)
   - Impact (Low / Med / High)
   - Time to implement
4. Recommend the best option with justification
5. Produce a concise action plan with owners and deadlines

## Output format

```
# Problem Analysis: [Problem Title]

## Problem Statement
[Clear, one-sentence restatement]

## Root Cause (5 Whys)
1. Why → ...
2. Why → ...
3. Why → ...
4. Why → ...
5. Root cause: ...

## Solution Options
| Option | Effort | Impact | Time | Trade-off |
|--------|--------|--------|------|-----------|
| A: ... | Low    | High   | 2d   | ...       |

## Recommendation
**Option [X]** — [1-2 sentence justification]

## Action Plan
| Action | Owner | Due |
|--------|-------|-----|
| ...    | ...   | ... |
```

## Notes

- If root cause is unclear after 5 Whys, flag as "hypothesis" and recommend validation step
- Tone: analytical and decisive — avoid vague language
- Suitable for escalation documents or retrospective inputs
