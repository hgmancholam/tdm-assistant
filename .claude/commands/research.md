# research

Research a topic deeply across multiple sources and produce a structured briefing.

## Usage

```
/research <topic>
```

## Behavior

1. Decompose the topic into 2-3 distinct search angles (e.g., overview, recent news, technical details)
2. Run a WebSearch for each angle
3. Use WebFetch on the most relevant page per angle
4. Synthesize all findings into a structured briefing

## Output format

### Summary
[2-3 sentence overview]

### Key Points
- [finding 1]
- [finding 2]
- [finding 3]
- ...

### Context / Background
[relevant background that frames the key points]

### Open Questions
- [anything unclear or worth investigating further]

### Sources
- [title](url)
- [title](url)

## Notes

- Aim for breadth across sources, not depth on one
- Flag conflicting information explicitly rather than picking one version
- Keep the briefing scannable — bullet points over paragraphs
- Useful for: vendor research, technology evaluations, meeting prep, understanding a project or incident
