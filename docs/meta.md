# Meta knowledge base (stable entrypoint)

This file is the **only stable entrypoint** downstream knowledge bases should reference.
Everything else in this repository may evolve; links from here will be kept current.

## What this system standardizes

This system does **not** mandate document taxonomies. It standardizes:

**Core dimensions (established):**
- **Entrypoints**: where humans and agents begin
- **Authority**: what counts as canonical truth
- **Provenance**: how to ground important claims in sources
- **Lifecycle**: draft → working → stable → deprecated
- **Strategy**: how to choose an organization approach and evolve it with evidence
- **Linking**: how to keep browser navigation intuitive

**New dimensions (2026):**
- **Temporal layers**: organizing ephemeral, tracking, and durable knowledge
- **KB dependencies**: managing cross-repository knowledge relationships
- **Evolution triggers**: evidence-based approach to adding complexity
- **Generated content**: when and how to automate documentation
- **Multi-agent coordination**: patterns for specialized agent collaboration (experimental)

## Read next

### Core Policies

Essential patterns for all knowledge bases:

- [Authority](../policies/authority.md) - What counts as canonical truth
- [Provenance](../policies/provenance.md) - Grounding claims in sources
- [Lifecycle](../policies/lifecycle.md) - Document status progression
- [Linking](../policies/linking.md) - Navigation and references
- [Intent-revealing structure](../policies/intent-revealing-structure.md) - File and directory naming
- [Write boundaries](../policies/writes.md) - Safe agent editing zones
- [Style](../policies/style.md) - Plain language and structure

### Extended Policies

For evolving and complex knowledge bases:

- [Temporal layers](../policies/temporal-layers.md) - Organizing ephemeral, tracking, and durable knowledge (NEW)
- [Generated content](../policies/generated-content.md) - When to automate documentation (NEW)

### Organization Strategies

Choose your approach:

- [Knowledge organization strategies](strategies/README.md)
  - Handbook (curated onboarding)
  - Atomic notes + maps (research/exploration)
  - Source-first synthesis (auditability)
  - Metadata + generated views (scale)

### Playbooks

Step-by-step guidance:

- [Choose a strategy](../playbooks/choose-strategy.md) - Initial organization decisions
- [Evolve a knowledge base](../playbooks/evolve-kb.md) - Evidence-based evolution (ENHANCED)
- [Manage KB dependencies](../playbooks/manage-kb-dependencies.md) - Cross-repository coordination (NEW)
- [Track spec-impl relationship](../playbooks/track-spec-impl-relationship.md) - Specification-to-implementation tracking (NEW)
- [Agent workflow](../playbooks/agent-workflow.md) - Plan → Patch → Verify pattern
- [Multi-agent coordination](../playbooks/multi-agent-coordination.md) - Specialized agent collaboration (NEW - Experimental)

## Quick Start Paths

### For a new knowledge base

1. Create `knowledge-base.yaml` with entrypoints
2. Add simple `docs/README.md` and optional `docs/agents.md`
3. Evolve based on pain (see [Evolve KB playbook](../playbooks/evolve-kb.md))

### For an evolving knowledge base

1. Review [Evolution triggers](../playbooks/evolve-kb.md#evidence-based-evolution-triggers)
2. Add what you need based on observed pain
3. Start with low-cost moves (entrypoints, lifecycle markers)
4. Iterate based on evidence

### For multi-repository projects

1. Separate specs from implementation if needed (see [KB dependencies](../playbooks/manage-kb-dependencies.md))
2. Declare relationship types in knowledge-base.yaml
3. Establish sync policies
4. Track drift explicitly

### For agent-augmented development

1. Define human and agent entrypoints
2. Set write boundaries
3. Use Plan → Patch → Verify pattern (see [Agent workflow](../playbooks/agent-workflow.md))
4. Consider multi-agent patterns if you have role separation (see [Multi-agent coordination](../playbooks/multi-agent-coordination.md))

## Philosophy

**Minimal intervention:** Only standardize operations, not structure

**Evidence-driven:** Evolve based on observed pain, not speculation

**Support evolution:** Knowledge bases that grow and adapt over time

**Agent-friendly:** Clear entrypoints, boundaries, and coordination patterns

**Human-centered:** Git is source of truth, UIs are views

## If you are a downstream repository

Add a `knowledge-base.yaml` at your repo root and include a single link to this entrypoint:

```yaml
meta:
  entrypoint: "../meta-knowledge-base/docs/meta.md"

imports:
  - kind: local
    path: ../meta-knowledge-base
    entrypoint: meta.yaml
```

Or reference via URL:
- https://forgejo.example/your-org/meta-knowledge-base/src/branch/main/docs/meta.md

See the [examples](../examples/) for complete configurations.

---

**Last updated:** 2026-01-11 (added intent-revealing structure policy)
