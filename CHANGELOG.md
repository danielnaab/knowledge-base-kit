# Changelog

Notable changes to the meta-knowledge-base.

## 2026-01-05 - Evolution for Evolving Knowledge Bases

Based on analysis of the Graft project's evolution through 53 commits and observation of real pain points in managing knowledge across multiple repositories, added five major enhancements:

### New Policies

**[Temporal Layers Policy](policies/temporal-layers.md)** - NEW
- Extends lifecycle policy with three temporal layers: ephemeral, tracking, durable
- Introduces "living documents" concept for always-current state tracking
- Provides migration paths between layers (ephemeral → durable, tracking → archived)
- Addresses gap: Previous guidance only distinguished docs/ from notes/, but many projects need intermediate tracking layer

**[Generated Content Policy](policies/generated-content.md)** - NEW
- Guidance on when to generate vs. handwrite documentation
- Three generation levels: indexes, extracted summaries, fully generated
- Patterns for marking generated content and maintaining boundaries
- Pain triggers for automation (synchronization, scale, consistency)
- Addresses gap: No previous guidance on automation vs. manual documentation

### Enhanced Playbooks

**[Evolve a Knowledge Base](playbooks/evolve-kb.md)** - ENHANCED
- Added comprehensive evidence-based evolution triggers section
- Five pain types with concrete signals and thresholds: navigation, authority, maintenance, handoff, discovery
- Decision framework: name pain → count occurrences → minimal intervention → observe → iterate
- Evolution moves ordered by cost (low to high)
- Anti-patterns: premature infrastructure, over-engineering, speculative evolution
- Addresses gap: Previous version was minimal, lacked concrete guidance on when/how to evolve

**[Manage KB Dependencies](playbooks/manage-kb-dependencies.md)** - NEW
- Patterns for cross-repository knowledge coordination
- Four relationship types: foundational, canonical-source, peer, generated-from
- Three sync policies: interpret, extend, reference
- Tracking drift between dependent knowledge bases
- Cross-repository provenance patterns
- Addresses gap: No previous guidance for multi-repository knowledge management

**[Multi-Agent Coordination](playbooks/multi-agent-coordination.md)** - NEW (Experimental)
- Patterns for multiple specialized agents collaborating
- Three coordination patterns: sequential handoff, concurrent with boundaries, collaborative with locks
- Communication protocols (commit messages, status signaling, shared task boards)
- Role definition and write boundaries
- Marked experimental - based on emerging patterns
- Addresses gap: Single-agent workflows documented, but no multi-agent guidance

### Enhanced Core Documentation

**[meta.md](docs/meta.md)** - UPDATED
- Added "New dimensions (2026)" section
- Organized policies into Core vs. Extended
- Added Quick Start Paths for different use cases
- Enhanced Philosophy section
- Preserved stable entrypoint guarantee while expanding guidance

## Philosophy Maintained

All additions maintain core meta-KB principles:

- **Minimal intervention**: Don't mandate structure, provide patterns
- **Evidence-driven**: Based on observed pain from real projects (Graft)
- **Optional guidance**: All new content is opt-in, not required
- **Stable entrypoint**: meta.md remains single reference point
- **Support evolution**: Explicitly for knowledge bases that grow over time

## Evidence Base

These additions are grounded in:

1. **Graft project analysis**: 53 commits, 84 files changed, 15k+ lines of implementation + documentation
2. **Observed pain points**:
   - Status documents needing lifecycle distinct from docs/notes
   - Cross-repository coordination between graft and graft-knowledge
   - Unclear when to add complexity vs. stay simple
   - Questions about generating vs. handwriting docs
3. **Gap analysis**: Meta-KB provided excellent foundation but lacked guidance for:
   - Projects that evolve significantly over time
   - Multi-repository knowledge dependencies
   - Evidence-based triggers for adding infrastructure
   - Automation decisions

## Usage

**For existing downstream repositories:**
- New policies and playbooks are optional enhancements
- Core policies (authority, provenance, lifecycle, linking) unchanged
- Review [evolution triggers](playbooks/evolve-kb.md#evidence-based-evolution-triggers) to decide what to adopt

**For new repositories:**
- Start simple (entrypoints, basic docs)
- Add complexity only when pain is observed
- Use evolution triggers as decision framework

**For evolving projects:**
- [Temporal layers](policies/temporal-layers.md) helps organize docs/, status/, notes/
- [KB dependencies](playbooks/manage-kb-dependencies.md) for multi-repo coordination
- [Evolution playbook](playbooks/evolve-kb.md) provides decision framework

## Related Work

**Graft implementation improvements:**
See `/home/coder/graft/docs/plans/meta-kb-compliance-improvements.md` for systematic plan applying these patterns to improve Graft's compliance from ~80% to 95%+.

**Analysis:**
See `/home/coder/graft/notes/2026-01-05-meta-knowledge-base-compliance-analysis.md` for detailed analysis identifying gaps and opportunities.

---

**Contributor:** Claude Sonnet 4.5 (deep analysis + evidence-based enhancement)
**Review status:** Ready for community feedback
**Next:** Gather feedback from downstream projects on utility of new guidance
