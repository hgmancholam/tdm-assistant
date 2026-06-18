# web-search

Search the web for a query and return a concise, synthesized answer.

## Usage

```
/web-search <query>
```

## Behavior

1. Use WebSearch to run the query
2. From the top results, use WebFetch on the 1-2 most relevant pages
3. Return a **3-5 sentence synthesis** with source URLs at the end

## Output format

**Answer:** [concise synthesis]

**Sources:**
- [title](url)
- [title](url)

## Notes

- If the query is ambiguous, ask one clarifying question before searching
- Prefer official documentation, news, or authoritative sources over aggregators
- If results are in a language other than the user's query language, translate the key points
