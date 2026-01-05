# Multi-Agent Coordination

**Status:** Experimental - based on emerging patterns from agent-augmented development

Guidance for knowledge bases where multiple agents with different roles collaborate.

## When You Need This

Consider multi-agent patterns when you have:
- Separate specification and implementation workflows
- Specialized agents for different tasks (coding, documenting, testing)
- Multiple concurrent development streams
- Clear role boundaries in knowledge work

**Warning:** Most projects don't need this complexity. Start with single-agent workflows and introduce coordination only when you have clear evidence of benefit.

## Define Agent Roles

Declare agent roles explicitly in `knowledge-base.yaml`:

```yaml
agents:
  spec-writer:
    entrypoint: docs/agents-spec.md
    role: "Define what to build"
    responsibilities:
      - "Write specifications"
      - "Make architectural decisions"
      - "Update decision records"
    write_boundaries:
      allow: ["docs/specification/**", "docs/decisions/**"]
      deny: ["src/**", "tests/**"]

  developer:
    entrypoint: docs/agents-impl.md
    role: "Implement according to specifications"
    responsibilities:
      - "Write production code"
      - "Write tests"
      - "Document implementation details"
    write_boundaries:
      allow: ["src/**", "tests/**", "docs/guides/**", "notes/**"]
      deny: ["docs/specification/**"]
      must_review: ["docs/architecture.md"]  # Can edit but needs human review

  documentation-maintainer:
    entrypoint: docs/agents-docs.md
    role: "Keep documentation synchronized with reality"
    responsibilities:
      - "Sync docs with code/specs"
      - "Fix documentation bugs"
      - "Improve examples and guides"
    write_boundaries:
      allow: ["docs/**"]
      must_verify: ["docs/specification/**"]  # Can edit but should verify with spec-writer
```

## Coordination Patterns

### Pattern 1: Sequential Handoff

**Use when:** Clear pipeline, each stage depends on previous

**Flow:**
1. Spec agent writes/updates specification
2. Commits with tag: `@impl-agent: Ready for implementation`
3. Impl agent reads spec, builds feature
4. Commits with tag: `@docs-agent: Ready for documentation`
5. Docs agent synchronizes documentation

**Example commit message:**
```
feat: Add lock file v2 format specification

Defines new metadata section and migration path from v1.

@impl-agent: Ready for implementation

See: docs/specification/lock-file-format.md
Tasks:
- Update parser for metadata field
- Add v1 to v2 migration
- Tests for new format
```

**Advantages:**
- Clear handoff points
- No concurrent conflicts
- Easy to track progress

**Disadvantages:**
- Sequential (slower)
- Potential bottlenecks

### Pattern 2: Concurrent with Boundaries

**Use when:** Work can proceed in parallel without conflicts

**Structure:**
- Non-overlapping write zones
- Each agent owns specific directories
- Minimal coordination needed

**Directory boundaries:**
```
project/
├── specs/              # spec-writer owns
├── src/                # developer owns
├── tests/              # developer owns
├── docs/guides/        # docs-maintainer owns
└── docs/decisions/     # spec-writer owns
```

**Coordination:**
- Agents work simultaneously
- Git branch per agent (optional)
- Merge conflicts indicate boundary violation
- Human mediates if boundaries need adjustment

**Advantages:**
- Parallel work (faster)
- Clear ownership
- Minimal coordination overhead

**Disadvantages:**
- Requires careful boundary design
- May need human mediation

### Pattern 3: Collaborative with Locks

**Use when:** Agents need to work on same documents

**Mechanism:**
```yaml
# Document frontmatter
---
status: stable
locked_by: spec-agent
locked_until: 2026-01-05T15:00:00
lock_reason: "Adding v2 format spec"
---
```

**Protocol:**
1. Agent checks document frontmatter for lock
2. If locked by another agent, skip or wait
3. Acquire lock by updating frontmatter
4. Complete work and release lock
5. Commit includes lock release

**Coordination file:**
```yaml
# .agent-locks.yaml
locks:
  - document: docs/architecture.md
    agent: spec-agent
    expires: 2026-01-05T15:00:00
    reason: "Major architecture update"
```

**Advantages:**
- Explicit coordination
- Prevents conflicts on shared docs
- Clear ownership at any moment

**Disadvantages:**
- Added complexity
- Potential for stale locks
- Requires lock management

## Communication Protocols

### Agent-to-Agent Messages

**In commit messages:**
```
@agent-name: Message content

Context and details...
```

**Examples:**
```
@impl-agent: Lock file v2 spec ready for implementation

Specification: docs/specification/lock-file-format.md
Changes: Added metadata section, migration guide from v1

Action required:
- Update LockFileAdapter for new format
- Add migration function
- Tests for v2 format and v1→v2 migration

Timeline: Ready when you are
Priority: Medium (needed for Phase 9)
```

```
@docs-agent: Implementation complete, needs documentation sync

Modified files:
- src/services/lock_service.py (added v2 support)
- tests/unit/test_lock_service.py (v2 tests)

Documentation needs:
- User guide: how to use metadata field
- Migration guide: upgrading from v1
- CLI reference: new flags for v2

Specification: docs/specification/lock-file-format.md
```

### Status Signaling

**In document frontmatter:**
```yaml
---
status: working
assigned_to: impl-agent
next_action: "Implement lock file v2 parser"
blocks: []
blocked_by: []
updated: 2026-01-05
---
```

**Blocking indicators:**
```yaml
---
status: working
assigned_to: docs-agent
blocked_by:
  - "Waiting for impl-agent to complete v2 implementation"
  - issue: "src/services/lock_service.py needs completion"
updated: 2026-01-05
---
```

### Shared Task Board

**tasks.yaml:**
```yaml
tasks:
  - id: lock-v2-spec
    owner: spec-agent
    status: completed
    completed: 2026-01-03

  - id: lock-v2-impl
    owner: impl-agent
    status: in-progress
    started: 2026-01-04
    depends_on: [lock-v2-spec]

  - id: lock-v2-docs
    owner: docs-agent
    status: pending
    depends_on: [lock-v2-impl]
```

## Best Practices

### Clear Role Definition

Each agent should have:
- **Single clear purpose** (spec, implement, document, test)
- **Defined entrypoint** (docs/agents-{role}.md)
- **Explicit write boundaries** (allow/deny lists)
- **List of responsibilities** (what they do/don't do)

### Minimize Coordination Overhead

- **Prefer boundaries over locks** (non-overlapping work)
- **Prefer async over sync** (commit messages, not real-time)
- **Prefer simple over complex** (sequential before concurrent)
- **Prefer explicit over implicit** (clear handoffs)

### Human Mediation

Humans should mediate:
- Boundary conflicts (two agents need same file)
- Priority decisions (what to work on next)
- Architectural questions (multiple valid approaches)
- Deadlocks (circular dependencies)

### Documentation of Coordination

**In knowledge-base.yaml:**
```yaml
coordination:
  pattern: "concurrent-with-boundaries"  # or sequential, collaborative
  conflict_resolution: "human-mediated"
  handoff_mechanism: "commit-messages"
```

**In agent entrypoints:**
```markdown
# Agent: Developer

## Coordination Protocol

**Handoffs from spec-agent:**
- Watch for `@impl-agent` in commit messages
- Specification changes trigger implementation work
- Ask questions via git commit responses

**Handoffs to docs-agent:**
- Tag commits with `@docs-agent` when feature complete
- List changed files and documentation needs
- Link to relevant specifications
```

## Workflow Examples

### Example 1: Feature Development

**Spec agent:**
```bash
# Create feature specification
vim docs/specification/new-feature.md

git add docs/specification/new-feature.md
git commit -m "spec: Add new feature specification

@impl-agent: Ready for implementation

Specification: docs/specification/new-feature.md
Priority: High
Estimated complexity: Medium
"
```

**Impl agent:**
```bash
# See spec agent commit, read specification
cat docs/specification/new-feature.md

# Implement feature
vim src/features/new_feature.py
vim tests/test_new_feature.py

git add src/ tests/
git commit -m "feat: Implement new feature

Implements specification from docs/specification/new-feature.md

@docs-agent: Ready for documentation

Changed:
- src/features/new_feature.py (new)
- tests/test_new_feature.py (new)

Docs needed:
- User guide section on using new feature
- API reference for new functions
"
```

**Docs agent:**
```bash
# See impl agent commit, review implementation
cat src/features/new_feature.py

# Update documentation
vim docs/guides/user-guide.md
vim docs/api-reference.md

git add docs/
git commit -m "docs: Add documentation for new feature

Documents feature implemented in <commit-hash>

- Added user guide section
- Updated API reference
- Added examples
"
```

### Example 2: Bug Fix

**Developer agent:**
```bash
# Fix bug in implementation
vim src/services/broken_service.py

git commit -m "fix: Correct validation logic in broken_service

@docs-agent: Check if user guide needs update
@spec-agent: Validation behavior changed, verify spec alignment

Changed behavior:
- Now validates X before Y (was opposite)
- May need spec update if old behavior was intentional
"
```

**Spec agent:**
```bash
# Review change, determine if spec needs update
# Option 1: Spec was wrong
vim docs/specification/service-spec.md
git commit -m "spec: Correct validation order in specification

Aligns with fix from <commit-hash>. Original spec was incorrect.
"

# Option 2: Implementation is wrong
git commit -m "spec: Validation spec is correct as-is

@impl-agent: Revert <commit-hash>, original validation order was intentional

Rationale: [explanation]
"
```

## Anti-Patterns

**Avoid:**

❌ **Too many roles** - Start with 1-2, add only if needed

❌ **Unclear boundaries** - Overlapping responsibilities cause conflicts

❌ **No handoff protocol** - Agents don't know when to act

❌ **Real-time coordination** - Asynchronous is simpler

❌ **Complex locking** - Usually indicates boundary problems

❌ **Agent-to-agent negotiation** - Human should decide conflicts

## When to Use Single Agent

**Use single agent when:**
- Project is small (<10k LOC)
- Clear sequential workflow
- One person/agent doing all work
- Coordination cost > benefit

**Use multiple agents when:**
- Clear role separation (spec vs. impl vs. docs)
- Parallel work streams beneficial
- Large codebase with distinct areas
- Proven handoff pain points

## Measurement and Evolution

**Track coordination pain:**
- Merge conflicts from agent overlap
- Time spent on handoffs
- Messages needed to clarify work
- Blocked time waiting for other agent

**Evolve patterns based on evidence:**
- Conflicts → adjust boundaries
- Slow handoffs → simplify protocol
- Frequent questions → improve entrypoints
- Deadlocks → add human mediation points

## Related

- [Agent workflow](agent-workflow.md) - Single agent patterns
- [Write boundaries policy](../policies/writes.md) - Defining safe edit zones
- [Manage KB dependencies](manage-kb-dependencies.md) - Cross-repo coordination

## Examples

**Graft project coordination:**
- `graft-knowledge` KB (spec-focused)
- `graft` KB (implementation-focused)
- Separate agents, concurrent work
- Coordination via canonical sources and imports

See: [graft knowledge-base.yaml](../../graft/knowledge-base.yaml)

---

**Note:** This is experimental guidance based on emerging patterns. If you're using multi-agent coordination, please share your learnings to help evolve these patterns.
