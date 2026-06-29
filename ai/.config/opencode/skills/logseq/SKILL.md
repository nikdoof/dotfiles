---
name: logseq
description: Read or write notes to a PKM system hosted in Logseq
---

Logseq is a PKM note taking system used by the user. This skill provides access to the PKM via the API and direct file access.

The Logseq PKM is located in ~/Logseq/PKM

## File Naming Conventions

- **Journals**: `journals/YYYY_MM_DD.md` (e.g. `journals/2026_03_24.md`)
- **Pages**: `pages/<title>.md` — page titles with `/` hierarchy use `___` (triple lowbar) as separator (e.g. `pages/Portwest___Middleware.md` = `[[Portwest/Middleware]]`)
- **Assets**: `assets/` — PDFs, images, audio referenced from pages/journals

## Content Format

All files use Logseq's block-based Markdown:

```markdown
- Block content here
  - Child block (indented with tab)
    property:: value
  - TODO Task item
  - DONE Completed task
```

Key conventions in this graph:

- Workflow: `TODO` / `DOING` / `DONE` (not NOW/LATER)
- Task scheduling: `SCHEDULED: <2026-03-24 Mon>`
- Page references: `[[Page Name]]` or `[[Portwest/Middleware]]`
- Tags: `#TagName` (also creates page references)
- Properties are inline: `property:: value` on a child block
- People have their own pages, so reference them if provided with a full name.
- Focus tasks / priorty tasks have a tag of `#Focus`
- Markdown is supported, but rather than using headers make use of blocks and indentation instead.

## Content Organization

- **`pages/`** — Reference notes, people, projects, technologies, books
- **`journals/`** — Daily entries since 2020, time-tracked with `#Wakeup` and `#WorkTime` tags
- **`pages/Templates.md`** — All Logseq templates: Book, People, Meeting, Note, Structure Note, TP Ticket, Morning Tasks, Standup
- **`pages/Tag Taxonomy.md`** — Tag hierarchy used across the graph
- **`logseq/config.edn`** — Graph configuration (EDN format)

## Active Journal Queries (shown on journal pages)

Defined in `logseq/config.edn` under `:default-queries`:

1. **🔥 Tasks Scheduled Today** — TODOs with today's scheduled date
2. **🔍 Focus Tasks** — Tasks referencing `[[Focus]]`
3. **🔖 JIRA Ticket Tasks** — Tasks referencing pages matching `DIG-*`
4. **📕 All Tasks** — All open TODO items (collapsed by default)

## Logseq HTTP API

The API is available at `http://localhost:12315/api` when Logseq is running. All requests are `POST` with `Authorization: Bearer claude` and `Content-Type: application/json`.

```bash
curl -X POST http://localhost:12315/api \
  -H "Authorization: Bearer claude" \
  -H "Content-Type: application/json" \
  -d '{"method":"<method>","args":[...]}'
```

**Prefer the API over direct file edits when Logseq is open** — file edits while Logseq is running can cause sync conflicts.

### logseq.Editor — pages

| Method                    | Args                         | Returns                         | Notes                                       |
| ------------------------- | ---------------------------- | ------------------------------- | ------------------------------------------- |
| `getPage`                 | `[nameOrId]`                 | `PageEntity`                    | Metadata only; no blocks                    |
| `getAllPages`             | `[]`                         | `PageEntity[]`                  | All pages and journals                      |
| `getPageBlocksTree`       | `[nameOrId]`                 | `BlockEntity[]`                 | Full block tree for a page                  |
| `getPageLinkedReferences` | `[nameOrId]`                 | `[PageEntity, BlockEntity[]][]` | Pages that link to this page                |
| `getPagesFromNamespace`   | `[namespace]`                | `PageEntity[]`                  | e.g. `"Portwest"` → all `Portwest/*` pages  |
| `createPage`              | `[name, properties?, opts?]` | `PageEntity`                    | opts: `{journal, format, createFirstBlock}` |
| `createJournalPage`       | `[date]`                     | `PageEntity`                    | Accepts JS Date or date string              |
| `renamePage`              | `[oldName, newName]`         | `void`                          |                                             |
| `deletePage`              | `[name]`                     | `void`                          | Also sends to `.recycle/`                   |

### logseq.Editor — blocks

| Method                    | Args                           | Returns         | Notes                                               |
| ------------------------- | ------------------------------ | --------------- | --------------------------------------------------- |
| `getBlock`                | `[uuidOrId, opts?]`            | `BlockEntity`   | opts: `{includeChildren: true}`                     |
| `appendBlockInPage`       | `[page, content, opts?]`       | `BlockEntity`   | Adds top-level block at end; opts: `{properties}`   |
| `prependBlockInPage`      | `[page, content, opts?]`       | `BlockEntity`   | Adds top-level block at start                       |
| `insertBlock`             | `[srcUUID, content, opts?]`    | `BlockEntity`   | opts: `{sibling, before, properties, customUUID}`   |
| `insertBatchBlock`        | `[srcUUID, batch, opts?]`      | `BlockEntity[]` | `batch` is `{content, children?}` or array thereof  |
| `updateBlock`             | `[uuid, content, opts?]`       | `void`          | opts: `{properties}` to set properties at same time |
| `removeBlock`             | `[uuid]`                       | `void`          |                                                     |
| `moveBlock`               | `[srcUUID, targetUUID, opts?]` | `void`          | opts: `{before, children}`                          |
| `getNextSiblingBlock`     | `[uuid]`                       | `BlockEntity`   |                                                     |
| `getPreviousSiblingBlock` | `[uuid]`                       | `BlockEntity`   |                                                     |

### logseq.Editor — properties

| Method                | Args                 | Notes                                           |
| --------------------- | -------------------- | ----------------------------------------------- |
| `getBlockProperties`  | `[uuid]`             | Returns all `key:: value` properties on a block |
| `upsertBlockProperty` | `[uuid, key, value]` | Insert or update a single property              |
| `removeBlockProperty` | `[uuid, key]`        | Delete a property                               |
| `getPageProperties`   | `[pageName]`         | Properties defined on the page itself           |

### logseq.DB — queries

| Method            | Args                 | Notes                         |
| ----------------- | -------------------- | ----------------------------- |
| `datascriptQuery` | `[query, ...inputs]` | Full DataScript/Datalog query |
| `q`               | `[dsl]`              | Simpler DSL query             |

### logseq.App

| Method                     | Args                         | Notes                                                        |
| -------------------------- | ---------------------------- | ------------------------------------------------------------ |
| `getCurrentGraph`          | `[]`                         | Returns `{name, path, url}`                                  |
| `getUserConfigs`           | `[]`                         | Returns preferred format, workflow, date format, theme, etc. |
| `getCurrentGraphTemplates` | `[]`                         | All templates as `Record<name, BlockEntity>`                 |
| `getTemplate`              | `[name]`                     | Single template block                                        |
| `insertTemplate`           | `[targetUUID, templateName]` | Apply a named template                                       |
| `openExternalLink`         | `[url]`                      | Open URL in default browser                                  |

### logseq.UI

| Method    | Args                        | Notes                                         |
| --------- | --------------------------- | --------------------------------------------- |
| `showMsg` | `[content, status?, opts?]` | `status`: `"success"`, `"warning"`, `"error"` |

### logseq.Assets

| Method                    | Args      | Notes                                         |
| ------------------------- | --------- | --------------------------------------------- |
| `listFilesOfCurrentGraph` | `[exts?]` | List asset files; `exts` e.g. `["pdf","png"]` |
| `makeUrl`                 | `[path]`  | Resolve asset path to URL                     |

### logseq.Git

| Method        | Args     | Notes                                                 |
| ------------- | -------- | ----------------------------------------------------- |
| `execCommand` | `[args]` | Run any git command, e.g. `["log","--oneline","-10"]` |

### Key data types

**BlockEntity** fields most useful for reading/writing:

- `uuid` — use this as the identifier in all API calls
- `content` — raw Markdown text of the block
- `marker` — `"TODO"`, `"DOING"`, `"DONE"`, or absent
- `properties` — `Record<string, any>` of inline `key:: value` pairs
- `children` — nested `BlockEntity[]` (only present with `includeChildren` or from tree calls)
- `page.id` — parent page's numeric id

**PageEntity** fields:

- `name` — lowercase canonical name
- `originalName` — display name (use this in API calls)
- `journal?` — `true` for daily journal pages
- `journalDay` — `YYYYMMDD` integer for journals
- `namespace.id` — present if page is in a namespace hierarchy

### Useful query examples

```bash
# All open TODO blocks with content
'{"method":"logseq.DB.datascriptQuery","args":["[:find (pull ?b [:block/uuid :block/content :block/marker]) :where [?b :block/marker \"TODO\"]]"]}'

# All blocks referencing a page (by page name)
'{"method":"logseq.DB.datascriptQuery","args":["[:find (pull ?b [*]) :where [?b :block/refs ?p] [?p :block/name \"focus\"]]"]}'

# Today's journal blocks
'{"method":"logseq.Editor.getPageBlocksTree","args":["Mar 24th, 2026"]}'

# Pages in a namespace
'{"method":"logseq.Editor.getPagesFromNamespace","args":["Portwest"]}'
```

### Journal page title format

Journal pages are referenced by display name (e.g. `"Mar 24th, 2026"`), not by filename. Use ordinal suffixes: 1st, 2nd, 3rd, 4th–20th, 21st, 22nd, 23rd, 24th–30th, 31st.

## Other notes

- **Direct file edits**: Safe when Logseq is closed; risky when open
- **Search index**: Rebuild after bulk file changes via Ctrl+C Ctrl+S inside Logseq
- **Backups**: Auto-snapshots in `logseq/bak/`; deleted pages in `logseq/.recycle/`
