---
name: doc-table-of-contents
description: Use when creating or substantially restructuring a repo Markdown document so the doc gets a manual table of contents near the top with anchor links to its main sections.
---

# Doc Table Of Contents

Use this skill for repo Markdown documents that are long enough to benefit from
navigation, especially design notes, plans, architecture docs, workflows, and
multi-section implementation notes.

## Default

Add a `## Table Of Contents` section near the top of the document, immediately
after the title and before the first major content section.

Use Markdown anchor links to the main sections, for example:

```md
## Table Of Contents

- [Overview](#overview)
- [Current State](#current-state)
- [Migration Path](#migration-path)
```

## When To Add One

Add a table of contents by default when:

- creating a new repo doc with multiple major sections
- expanding a short note into a design or planning document
- restructuring a doc so readers need to jump between sections

Skip it only when the document is very short and the navigation value would be
negligible.

## Scope

Include links to the main document sections.

Usually include:

- `##` headings
- important decision or recommendation sections
- major workflow, migration, or reference sections

Usually skip:

- very small subsections
- repetitive low-level headings
- headings that are likely to churn heavily during drafting unless they matter
  for navigation

## Guardrails

- Keep the table of contents manual rather than generated so it stays readable
  in plain Markdown.
- Use the document's actual heading text for link labels.
- Keep anchor links consistent with standard Markdown heading slugs.
- When adding or renaming major sections, update the table of contents in the
  same edit.
