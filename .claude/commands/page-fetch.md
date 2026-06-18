# page-fetch

Fetch and summarize the content of a specific URL.

## Usage

```
/page-fetch <url>
/page-fetch <url> <instruction>
```

**Examples:**
- `/page-fetch https://example.com/article`
- `/page-fetch https://example.com/doc extract action items`
- `/page-fetch https://example.com/meeting-notes translate to English and summarize`

## Behavior

1. Use WebFetch to retrieve the page content
2. Apply the optional instruction if provided (summarize, extract action items, translate, etc.)
3. If no instruction is given, return a structured summary

## Default output format (no instruction)

**Title:** [page title]

**Summary:** [3-5 sentence overview]

**Key Points:**
- [point 1]
- [point 2]

**Source:** [url]

## Notes

- If the URL is behind authentication or returns an error, report it clearly
- For long pages, focus on the main content and ignore nav/footer/ads
- If the page is in another language, translate automatically unless the user specifies otherwise
