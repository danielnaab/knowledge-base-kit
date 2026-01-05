# Managing Knowledge Base Dependencies

Guidance for knowledge bases that import or depend on other knowledge bases.

## When to Use This

Your knowledge base has dependencies when you:
- Reference specifications from another repository
- Implement or interpret canonical documentation from elsewhere
- Build on foundational patterns from shared knowledge bases
- Coordinate with peer projects

## Declare Dependencies

In your `knowledge-base.yaml`:

```yaml
imports:
  - kind: local
    path: ../meta-knowledge-base
    entrypoint: meta.yaml
    relationship: "foundational"       # New: Declare relationship type

  - kind: local
    path: ../project-specs
    entrypoint: knowledge-base.yaml
    relationship: "canonical-source"   # New: How you relate to it
    sync_policy: "interpret"           # New: How you keep in sync
```

## Relationship Types

### Foundational

**Definition:** Provides patterns, policies, or infrastructure you build on

**Example:** meta-knowledge-base (provides KB management patterns)

**Characteristics:**
- You follow its guidance
- Changes are usually additive (new patterns)
- Low coupling - occasional reference

**Sync approach:**
- Review when major updates occur
- Adopt new patterns as needed
- No tight synchronization required

**In your docs:**
```markdown
This knowledge base follows [meta-knowledge-base](../meta-knowledge-base/) conventions for:
- Entrypoints ([meta.md](../meta-knowledge-base/docs/meta.md))
- Lifecycle management ([lifecycle policy](../meta-knowledge-base/policies/lifecycle.md))
- Provenance ([provenance policy](../meta-knowledge-base/policies/provenance.md))
```

### Canonical-Source

**Definition:** Source of truth you interpret, implement, or translate

**Example:** Specification KB for an implementation KB

**Characteristics:**
- It defines "what to build"
- You implement "how to build it"
- High coupling - changes propagate
- Authority flows from source to your KB

**Sync approach:**
- Interpret changes systematically
- Maintain provenance to source
- Track drift explicitly
- Review on every significant source update

**In your docs:**
```markdown
> **Authority Note:** This document interprets specifications from [project-specs](../project-specs/). For canonical decisions, see [architecture.md](../project-specs/docs/architecture.md).
```

### Peer

**Definition:** Related project, occasional cross-references

**Example:** Two implementation KBs sharing learnings

**Characteristics:**
- Independent evolution
- Occasional references
- Low coupling
- Mutual influence, not authority

**Sync approach:**
- Standard markdown links
- No special synchronization
- Share insights opportunistically

**In your docs:**
```markdown
The [frontend project](../frontend-kb/) uses a similar approach for configuration management.
```

### Generated-From

**Definition:** Your KB is systematically derived from another source

**Example:** API docs generated from code, or translated documentation

**Characteristics:**
- Automated generation
- One-way flow (source → your KB)
- Your KB is derivative, not authoritative

**Sync approach:**
- Automated regeneration
- Mark generated content
- Human edits in separate overlay

**In your docs:**
```markdown
<!-- AUTO-GENERATED from ../api-specs/ -->
<!-- Generation script: scripts/generate-docs.py -->
<!-- Last generated: 2026-01-05 -->
```

## Sync Policies

### Interpret Policy

**Use when:** You're creating human-friendly interpretations of canonical technical content

**Requirements:**

1. **Add Sources sections** referencing canonical KB:
   ```markdown
   ## Sources

   This guide interprets:
   - [Core Specification](../canonical-kb/docs/spec.md)
   - [Data Models](../canonical-kb/docs/models.md)

   Implementation: `src/system/*.py`
   ```

2. **Mark interpretation docs** with authority boundaries:
   ```markdown
   > **Authority Note:** This is an interpretation of [canonical specs](../specs/). When in conflict, specs are authoritative.
   ```

3. **Review triggers:**
   - When canonical KB has significant updates
   - When you notice drift (your docs contradict source)
   - Monthly for active projects, quarterly for stable

4. **Track sync status:**
   ```markdown
   ## Sync Status

   Last synchronized with canonical-kb: 2026-01-03 (commit abc123)

   Known drift:
   - [ ] New API endpoints not yet documented
   - [ ] v2 format specified but not in user guide
   ```

**Example configuration:**
```yaml
imports:
  - kind: local
    path: ../specs
    relationship: "canonical-source"
    sync_policy: "interpret"
    last_synced: "2026-01-03"
    sync_trigger: "Significant spec changes"
```

### Extend Policy

**Use when:** Canonical KB provides foundation, you add project-specific details

**Requirements:**

1. **Mark inherited vs. added content:**
   ```markdown
   ## Error Handling (inherited)

   Follows [standard error handling](../foundation/docs/errors.md) with these additions:

   ### Project-Specific Errors (added)

   - `CustomDomainError` - ...
   ```

2. **Track foundation version:**
   ```yaml
   imports:
     - kind: local
       path: ../foundation
       relationship: "foundational"
       sync_policy: "extend"
       based_on_version: "v2.1"  # Track what you're extending
   ```

3. **Update when foundation changes:**
   - Review compatibility when foundation updates
   - Update your extensions if breaking changes
   - Document any deviations

### Reference Policy

**Use when:** Occasional links, no tight coupling

**Requirements:**
- Standard markdown links
- No special synchronization
- Document relationship in knowledge-base.yaml for clarity

```yaml
imports:
  - kind: local
    path: ../peer-project
    relationship: "peer"
    sync_policy: "reference"
    note: "Occasional shared learnings, independent evolution"
```

## Tracking Drift

For canonical-source relationships, explicitly track divergence:

### In Documentation

Add a "Sync Status" section to interpretation docs:

```markdown
## Sync Status

**Last synchronized:** 2026-01-03 (canonical-kb commit abc123)

**Sync frequency:** After significant spec changes, or monthly

**Known drift:**
- [ ] Spec added `metadata` field to lock file format - needs user guide update
- [ ] New `validate` command specified - needs CLI reference update
- [x] Change model now supports `verify` field - updated 2026-01-02

**Review schedule:** Next review 2026-02-01
```

### In knowledge-base.yaml

```yaml
imports:
  - kind: local
    path: ../graft-knowledge
    relationship: "canonical-source"
    sync_policy: "interpret"
    sync:
      last_check: "2026-01-03"
      canonical_commit: "abc123def"
      drift_tracking: "status/sync-status.md"
      review_frequency: "monthly"
```

## Cross-Repository Provenance

When referencing canonical sources, use clear provenance patterns:

### File References

**Relative paths from your repo:**
```markdown
See [canonical architecture](../canonical-kb/docs/architecture.md) for system design decisions.
```

**With heading anchors:**
```markdown
The [change model spec](../canonical-kb/docs/spec.md#change-model) defines the data structure.
```

**With commit pins (for stability):**
```markdown
Based on [spec v2.0](../canonical-kb/docs/spec.md) (commit abc123, 2026-01-01).
```

### In knowledge-base.yaml

Declare canonical sources:

```yaml
sources:
  canonical:
    - path: "../canonical-kb/docs/architecture.md"
      note: "Architecture decisions come from canonical KB"
    - path: "../canonical-kb/docs/specifications/**"
      note: "All format specifications are canonical"
    - path: "src/**/*.py"
      note: "Source code is canonical for our implementation"

  interpretation:
    - path: "docs/guides/**"
      note: "User-friendly interpretations of canonical specs"
    - path: "docs/architecture.md"
      note: "Developer overview, interprets canonical architecture"
```

## Directory Structure Patterns

### Pattern 1: Separate Spec and Implementation KBs

```
project/
├── specs-kb/                    # Canonical specifications
│   ├── docs/
│   │   ├── architecture.md      # What to build
│   │   ├── decisions/           # Design decisions
│   │   └── specifications/      # Detailed specs
│   └── knowledge-base.yaml
│
└── impl-kb/                     # Implementation
    ├── docs/
    │   ├── architecture.md      # How we built it (interprets specs-kb)
    │   └── guides/              # Practical usage
    ├── src/                     # Code
    ├── status/                  # Tracking
    └── knowledge-base.yaml      # Imports specs-kb as canonical-source
```

### Pattern 2: Shared Foundation

```
org/
├── meta-kb/                     # Organizational patterns
│   ├── policies/
│   └── playbooks/
│
├── project-a/                   # Imports meta-kb (foundational)
│   └── knowledge-base.yaml
│
└── project-b/                   # Also imports meta-kb (foundational)
    └── knowledge-base.yaml
```

### Pattern 3: Generated Documentation

```
project/
├── api/                         # Source of truth (code)
│   └── src/
│
└── docs-kb/                     # Generated-from api
    ├── docs/
    │   └── api-reference.md     # AUTO-GENERATED
    ├── scripts/
    │   └── generate-docs.py     # Generation script
    └── knowledge-base.yaml      # Declares generated-from relationship
```

## Best Practices

### Start Independent

Don't create dependencies prematurely:
- Start with single KB
- Extract to separate KB only when you have clear pain:
  - Multiple implementations need same specs
  - Specs stabilizing while impl still exploring
  - Clear authority boundary emerged

### Make Relationships Explicit

Always declare in knowledge-base.yaml:
- What you import
- Why (relationship type)
- How you sync (policy)

### Maintain Provenance

In interpretation docs:
- Link to canonical sources
- Mark authority boundaries
- Track sync status

### Regular Reviews

For canonical-source relationships:
- Review monthly during active development
- Review quarterly for stable projects
- Always review when canonical source has major changes

### Avoid Duplication

Don't copy content from canonical sources:
- Link to canonical content
- Summarize with clear attribution
- Focus your docs on what you add (implementation, interpretation, examples)

## Anti-Patterns

**Avoid:**

❌ **Silent imports:** Dependencies not declared in knowledge-base.yaml

❌ **Copy-paste without attribution:** Duplicating canonical content without provenance

❌ **Unclear authority:** Can't tell which KB is authoritative for what

❌ **No sync tracking:** Don't know if you're current with canonical source

❌ **Premature separation:** Splitting KBs before clear boundary exists

## Related

- [Authority policy](../policies/authority.md) - What counts as canonical
- [Provenance policy](../policies/provenance.md) - How to ground claims
- [Linking policy](../policies/linking.md) - How to reference across KBs

## Examples

**Graft project:**
- `graft-knowledge/` (canonical specs)
- `graft/` (implementation, imports graft-knowledge as canonical-source)
- Both import `meta-knowledge-base/` (foundational)

See: [graft knowledge-base.yaml](../../graft/knowledge-base.yaml)
