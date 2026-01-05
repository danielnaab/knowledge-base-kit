# Playbook: evolve a knowledge base

This playbook describes safe evolution without over-architecting.

## Core Principle: Evidence-Driven Evolution

**Don't evolve speculatively.** Wait for clear, repeated pain before adding complexity.

Only add infrastructure when you have:
- **3+ concrete examples** of the same pain
- **Evidence of cost** (time wasted, errors made, questions repeated)
- **Understanding** of what minimal intervention would help

## Evidence-Based Evolution Triggers

### Pain Type 1: Navigation Pain

**Signals:**
- Can't find information quickly
- Repeated "where is X documented?" questions
- New contributors take >30min to orient
- Same questions asked multiple times

**Threshold:** 3+ instances in one week

**Minimal intervention:**
- Add `## Contents` section to large files
- Create simple `index.md` with table of links

**Next level:**
- Map of content organized by purpose
- Separate docs by audience (user/developer/agent)

**Evidence from Graft:**
- Created `docs/index.md` with "I want to..." navigation when team repeatedly asked "where's the CLI reference?"

### Pain Type 2: Authority Pain

**Signals:**
- Documents contradict each other
- Documents contradict canonical sources (code, specs)
- Unclear which document is authoritative
- Changes ripple unpredictably

**Threshold:** Any conflict between canonical sources

**Minimal intervention:**
- Add authority note to conflicting doc
- Update knowledge-base.yaml with `sources.canonical`

**Next level:**
- Mark interpretation docs explicitly
- Add provenance to all operational guidance
- Establish sync tracking for dependencies

**Evidence from Graft:**
- Added canonical sources to knowledge-base.yaml when docs duplicated specs from graft-knowledge

### Pain Type 3: Maintenance Pain

**Signals:**
- Docs frequently out of sync with reality
- Weekly updates needed to keep docs accurate
- Code and docs tell different stories
- Nobody trusts the documentation

**Threshold:** Weekly sync burden

**Minimal intervention:**
- Add provenance links to canonical sources
- Link docs to code: `src/file.py:line`

**Next level:**
- Move closer to source of truth
- Consider generation for highly structured content
- Establish review triggers

**Evidence from practice:**
- API docs that manually track function signatures → generate from code

### Pain Type 4: Handoff Pain

**Signals:**
- Session transitions require >30min to understand state
- Work gets duplicated because state is unclear
- Questions like "what were you working on?" or "what's next?"
- Context loss between sessions

**Threshold:** Every handoff is costly

**Minimal intervention:**
- Add `continue-here.md` with current state
- Create `tasks.md` for active work

**Next level:**
- Add `status/` layer for implementation tracking
- Mark status docs as "working" with archive triggers
- Establish living document patterns

**Evidence from Graft:**
- Added status/ directory and continue-here.md when multi-day sessions required extensive context rebuilding

### Pain Type 5: Discovery Pain

**Signals:**
- Repeatedly grepping for same patterns
- "I know we documented this somewhere..."
- Can't find related information
- Manual aggregation across many files

**Threshold:** Daily search sessions for same content

**Minimal intervention:**
- Add tags to frontmatter
- Create simple index of key topics

**Next level:**
- Add metadata fields
- Generate queryable indexes
- Build search/filter tools

**Evidence from practice:**
- 30+ ADRs → created ADR index with status table

## Decision Framework

When pain is observed:

1. **Name the pain** (from types above)
2. **Count occurrences** (ensure it's real, not one-off)
3. **Try minimal intervention** (from list above)
4. **Observe** (did it solve the pain? measure impact)
5. **Iterate** (if pain persists, try next level)

## Evolution Moves (Low to High Cost)

Ordered by increasing complexity and commitment:

1. **Entrypoints** (human + agent)
   - Cost: <1 hour
   - Impact: Clear starting points
   - Reversibility: Easy

2. **Lifecycle markers**
   - Cost: 1-2 hours
   - Impact: Shows document maturity
   - Reversibility: Easy
   - See: [Lifecycle policy](../policies/lifecycle.md)

3. **Provenance on important claims**
   - Cost: 2-4 hours
   - Impact: Grounded, maintainable claims
   - Reversibility: Easy
   - See: [Provenance policy](../policies/provenance.md)

4. **Navigation index / map of content**
   - Cost: 2-3 hours
   - Impact: Easier discovery
   - Reversibility: Easy
   - See: [Linking policy](../policies/linking.md)

5. **Temporal layers** (docs/, status/, notes/)
   - Cost: 3-5 hours
   - Impact: Clearer organization, better archival
   - Reversibility: Moderate
   - See: [Temporal layers policy](../policies/temporal-layers.md)

6. **KB dependencies management**
   - Cost: 4-6 hours
   - Impact: Clear authority across repos
   - Reversibility: Moderate
   - See: [Manage KB dependencies](manage-kb-dependencies.md)

7. **Minimal metadata + generated views**
   - Cost: 8-16 hours
   - Impact: Queryable knowledge, automated indexes
   - Reversibility: Moderate-Hard
   - See: [Generated content policy](../policies/generated-content.md)

## Anti-Patterns to Avoid

**Premature infrastructure:**
- ❌ Inventing taxonomy before you have content
- ❌ Adding metadata nobody uses
- ❌ Creating multiple conflicting sources of truth
- ❌ Building UIs before understanding the domain
- ❌ Treating generated views as source of truth

**Over-engineering:**
- ❌ Complex hierarchies with <5 documents
- ❌ Elaborate metadata schemas with no queries
- ❌ Generated views with no clear use case
- ❌ Infrastructure requiring constant maintenance

**Speculative evolution:**
- ❌ "We might need this later"
- ❌ "This is how big projects do it"
- ❌ Adding structure before pain is observed

**The right approach:**
- ✅ Wait for 3+ instances of same pain
- ✅ Try minimal intervention first
- ✅ Measure if it helped
- ✅ Iterate based on evidence

## When to Stop Evolving

Signs you've evolved enough:

- ✅ Pain points are addressed
- ✅ Navigation is intuitive
- ✅ Maintenance burden is acceptable
- ✅ New contributors can orient quickly
- ✅ No frequent "where is X?" questions

**Remember:** Simplicity is a feature, not a bug. The best knowledge base is the simplest one that solves your actual problems.

## Related Playbooks

- [Choose a strategy](choose-strategy.md) - Initial organization approach
- [Manage KB dependencies](manage-kb-dependencies.md) - Multi-repository KBs
- [Agent workflow](agent-workflow.md) - Using KBs in agent sessions
