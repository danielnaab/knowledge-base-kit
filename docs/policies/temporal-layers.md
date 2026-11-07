---
status: stable
---
# Temporal layers policy

Knowledge bases often need three temporal layers: ephemeral, tracking, and durable. Two more are
optional, for knowledge bases that keep captured sources or a dated record.

## Ephemeral (notes/, explorations/)
- Purpose: scratch work, session logs
- Lifecycle: draft → archived
- Retention: days to weeks
- Archive when: insights extracted or session complete

## Tracking (status/, current-state/)
- Purpose: implementation progress, handoff
- Lifecycle: working → deprecated → archived
- Retention: weeks to months
- Archive when: milestone reached or work complete

## Durable (docs/, decisions/)
- Purpose: architecture, guides, decisions
- Lifecycle: draft → working → stable → deprecated
- Retention: indefinite
- Update when: system changes significantly

## Raw sources (optional: raw/, sources/)
- Purpose: material as captured (transcripts, exports, clippings) that other layers cite
- Lifecycle: none; never edited after capture
- Retention: indefinite, or as the source's own terms require
- Change when: a capture is replaced by a better one, or removed

## Historical (optional: records/, journal/)
- Purpose: dated records written once (daily notes, session logs, meeting notes)
- Lifecycle: none; the date in the path marks them, so no `status`
- Retention: indefinite
- Change when: correcting an error; add a dated correction rather than rewriting

## Living documents

Some documents are always current (continue-here.md, tasks.md):
- Mark with `status: living` in frontmatter
- Snapshot before major milestones
- Latest version is always current

## Migration paths

- Ephemeral → Durable: extract insights to docs
- Raw or Historical → Durable: synthesize into docs that cite them
- Ephemeral → Historical: keep a session log as a record instead of archiving it
- Tracking → Archived: snapshot when work completes
- Living → Snapshot: preserve state at milestones

Related:
- [Lifecycle policy](lifecycle.md)
- [Authority policy](authority.md)
- [Provenance policy](provenance.md)
