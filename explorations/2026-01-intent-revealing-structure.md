# Exploration: Intent-revealing structure principle

**Date**: 2026-01-11
**Status**: Proposed
**Context**: Observed pattern in digital-strategy MacBook architecture reorganization

## Motivation

During MacBook rebuild planning, a 400+ line decision document (`decision-0003-rebuild-architecture.md`) was split into focused files with descriptive names. The reorganization applied Robert Martin's "screaming architecture" principle: **the file structure should reveal the system's intent without opening files**.

This raised the question: Should this be a meta-knowledge-base principle?

## Current state of meta-knowledge-base

Existing policies address:
- **Linking**: How to connect documents
- **Authority**: Which documents are canonical
- **Provenance**: Where information comes from
- **Lifecycle**: How documents evolve over time
- **Style**: How to write content
- **Temporal layers**: Ephemeral vs tracking vs durable

**Missing**: How to name files and directories to reveal intent.

## Real-world example: digital-strategy MacBook architecture

### Before (opaque structure)
```
architecture/
└── decision-0003-rebuild-architecture.md  (400+ lines, all decisions)
```

**Navigation experience**:
- Q: "Where is the secrets management decision?"
- A: "Open decision-0003, search for section 3"
- Q: "What architecture decisions exist?"
- A: "Open decision-0003 and read the table of contents"

### After (intent-revealing structure)
```
architecture/
├── README.md
├── device-configuration/
│   ├── nix-darwin-declarative.md
│   ├── macos-user-accounts.md
│   └── browser-strategy.md
├── integrations/
│   ├── secrets-management.md
│   ├── homelab-access.md
│   └── ios-workflows.md
└── backup-recovery.md
```

**Navigation experience**:
- Q: "Where is the secrets management decision?"
- A: `architecture/integrations/secrets-management.md` (obvious from name)
- Q: "What architecture decisions exist?"
- A: `ls architecture/` reveals: device-configuration, integrations, backup-recovery

## When to apply this principle

### Strong indicators (apply immediately)
- Repository has 10+ files with opaque names
- Multiple "where is X?" questions per week
- Numbered files (decision-0001, doc-v2) that hide content
- Directories named by sequence (section-1, part-2) not purpose

### Weak indicators (consider, but may not need)
- Small repositories (<5 files)
- Single-purpose repositories where context is obvious
- Stable structure that everyone already knows

### Evidence from digital-strategy
After reorganization:
- **Before**: Had to read decision-0003 to understand what decisions existed
- **After**: `ls architecture/device-configuration` immediately shows nix-darwin, macos-accounts, browser options
- **Impact**: Reduced "where is X?" questions from 3-4 per session to 0

## Decision framework

### Question 1: Is there navigation pain?
Count occurrences of:
- "Where is the X documentation?"
- Opening wrong files before finding correct one
- Grep for content instead of navigating by name

**Threshold**: 3+ occurrences in one week → consider applying

### Question 2: Are names opaque?
Check for:
- Sequential numbers (decision-0001, doc-v2)
- Generic names (notes.md, misc.md)
- Abbreviated names (cfg.md, impl.md)
- Version suffixes (plan-v2.md)

**Heuristic**: If someone unfamiliar needs to open 3+ files to find information, names are too opaque.

### Question 3: Is structure flat or deep?
- **Flat** (all files in one directory): Consider grouping by purpose if >10 files
- **Deep** (5+ levels): Consider flattening if directory names are opaque

**Balance**: 2-3 levels with descriptive names > 5 levels with generic names

## Relation to existing principles

### Complements "Handbook" strategy
- Handbook assumes curated docs for onboarding
- Intent-revealing names make handbook navigable without reading everything first

### Complements "Atomic notes" strategy
- Atomic notes assume many small files
- Intent-revealing names prevent "which note has X?" problem at scale

### Addresses "Navigation pain" trigger
- Evolve-kb playbook identifies navigation pain as trigger for evolution
- Current minimal solution: "add index or contents section"
- This principle: **structure itself becomes the index**

## Trade-offs

### Accepts
- Longer file names (more descriptive = more characters)
- File renames when purpose shifts (intent changes = name changes)
- More directories (grouping by purpose = more hierarchy)

### Gains
- Grep by purpose (`grep -r "secrets" architecture/integrations/`)
- Self-documenting structure (new collaborators understand layout)
- Reduced README burden (don't need "here's where everything is")
- Faster handoffs (structure reveals organization)

### Risks
- Over-engineering structure prematurely
- False clarity (name implies content that isn't there)
- Churn from frequent renames

## Recommended policy language

Proposed policy: [intent-revealing-structure.md](../policies/intent-revealing-structure.md)

Key points:
1. File names reveal content without opening
2. Directory names reveal purpose
3. Structure communicates system architecture
4. Apply when navigation pain exceeds threshold (3+ "where is X?" per week)

## Open questions

1. **When to rename vs redirect?** If external references exist, should we create redirects or just rename?
2. **How specific is too specific?** Is `macos-user-accounts-work-personal-separation.md` too long?
3. **Generic vs descriptive?** When is `docs/` acceptable vs when should it be `architecture/` or `guides/`?

## Next steps

1. Review proposed policy with users
2. Gather feedback on clarity and applicability
3. Test policy application in 2-3 example repositories
4. Refine based on observed usage patterns
5. If validated, merge into main meta-knowledge-base

## Sources

- Robert Martin's "Screaming Architecture" concept
- digital-strategy repository reorganization (2026-01-11)
- Meta-knowledge-base existing policies
- Observed navigation pain patterns in knowledge bases
