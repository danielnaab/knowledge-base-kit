# Managing knowledge base dependencies

**Status:** stable

Guidance for knowledge bases that import or depend on others.

## Declare dependencies

In knowledge-base.yaml:

```yaml
imports:
  - kind: local
    path: ../meta-knowledge-base
    relationship: "foundational"

  - kind: local
    path: ../project-specs
    relationship: "canonical-source"
    sync_policy: "interpret"
```

## Relationship types

**Foundational** - provides patterns you build on
- Example: meta-knowledge-base
- Sync: review when major updates occur

**Canonical-source** - source of truth you interpret/implement
- Example: specification KB for implementation KB
- Sync: interpret changes, maintain provenance
- Track drift explicitly

**Peer** - related project, occasional references
- Sync: standard links, no special maintenance

**Generated-from** - your KB derived from another source
- Sync: automated regeneration, mark generated content

## Sync policies

**Interpret policy** (for canonical-source):
- Add Sources sections referencing canonical KB
- Mark interpretation docs with authority notes
- Review when canonical KB changes
- Track drift in sync status section

**Extend policy** (for foundational):
- Mark inherited vs added content
- Track version of canonical KB
- Update when foundation changes

**Reference policy** (for peer):
- Standard markdown links
- No special synchronization needed

## Cross-repository provenance

Use relative paths:
```markdown
[canonical architecture](../canonical-kb/docs/architecture.md)
```

Declare in knowledge-base.yaml:
```yaml
sources:
  canonical:
    - path: "../canonical-kb/docs/spec.md"
      note: "Specifications are canonical"
  interpretation:
    - path: "docs/guides/**"
      note: "Interprets canonical specs"
```

## Anti-patterns

Avoid:
- Silent imports (not declared in knowledge-base.yaml)
- Copy-paste without attribution
- Unclear authority (can't tell which KB is authoritative)
- No sync tracking
- Premature separation (split before clear boundary)

Related:
- [Authority policy](../policies/authority.md)
- [Provenance policy](../policies/provenance.md)
