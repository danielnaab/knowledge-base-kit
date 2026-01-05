# Temporal Layers Policy

Extends the [lifecycle policy](lifecycle.md) with guidance for multiple temporal layers in evolving knowledge bases.

## When to Use This

Apply temporal stratification when your knowledge base has:
- Active development or implementation tracking
- Session-based work requiring handoff documentation
- Mix of stable architecture and evolving status

## Three Temporal Layers

Many knowledge bases benefit from three temporal layers:

### 1. Ephemeral (notes/, explorations/)

**Purpose:** Scratch work, session logs, learning, temporary explorations

**Lifecycle:** draft → archived

**Characteristics:**
- Time-bounded (days to weeks)
- Personal or session-specific
- Raw thinking, not polished
- May extract insights for durable docs

**Retention:** Archive when insights extracted or session complete

**Examples:**
- `notes/2026-01-05-api-exploration.md`
- `notes/debugging-session-log.md`
- `explorations/alternative-approaches.md`

### 2. Tracking (status/, current-state/)

**Purpose:** Active work tracking, implementation progress, session handoff

**Lifecycle:** working → deprecated → archived

**Characteristics:**
- Medium-term (weeks to months)
- Project or milestone-specific
- Reflects current state, not final truth
- Useful for coordination and continuity

**Retention:** Deprecate when milestone reached, archive when work complete

**Special Case: Living Documents** (see below)

**Examples:**
- `status/implementation.md` (track progress)
- `status/gap-analysis.md` (track deltas)
- `continue-here.md` (session handoff)
- `tasks.md` (current work)

### 3. Durable (docs/, decisions/)

**Purpose:** Architecture, guides, decisions, reference documentation

**Lifecycle:** draft → working → stable → deprecated

**Characteristics:**
- Long-term (indefinite retention)
- Reviewed and maintained
- Aligned with canonical sources
- Include provenance where required

**Retention:** Keep indefinitely, update when system changes significantly

**Examples:**
- `docs/architecture.md`
- `docs/guides/user-guide.md`
- `docs/decisions/001-*.md` (ADRs)

## Living Documents

Some documents are **intentionally impermanent** - always reflecting current state rather than stable knowledge.

### Identifying Living Documents

Mark explicitly in frontmatter:

```yaml
---
status: living
purpose: "Always reflects current implementation state"
updated: 2026-01-05
archive_policy: "Snapshot at milestones, keep latest"
---
```

### Common Living Documents

**continue-here.md / session-handoff.md:**
- Always shows where you are now
- Snapshot before major milestones
- Latest version is always current

**tasks.md / current-work.md:**
- Tracks only active work
- Completed items removed (not accumulated)
- Git history provides evolution tracking

**status/current-state.md:**
- Reflects system state at any moment
- Updated continuously during active work
- Archive when work completes, state stabilizes

### Living Document Archival

**Snapshot policy:**
1. Before major milestones (branch merge, release, phase completion)
2. Copy to dated archive: `notes/archive/YYYY-MM-DD-snapshot-name.md`
3. Continue updating the living version
4. Git history preserves all states

**Example:**
```bash
# Before merging feature branch
cp continue-here.md notes/archive/2026-01-15-pre-merge-state.md
# Then update continue-here.md for next phase
```

## Migration Paths

### Ephemeral → Durable

**When:** Insights from exploration should be preserved

**Process:**
1. Extract key insights from notes
2. Add to appropriate durable docs (with provenance)
3. Archive original notes
4. Reference archived notes for historical context

**Example:**
```markdown
## Architecture Decision

After exploring alternatives ([2026-01-05 exploration](../notes/archive/2026-01-05-api-exploration.md)), we chose REST over GraphQL because...
```

### Tracking → Archived

**When:** Work completes, milestone reached

**Process:**
1. Create snapshot in `notes/archive/YYYY-MM-DD-description.md`
2. Mark original as deprecated with pointer
3. Remove from active navigation (index, README)
4. Keep for historical reference

**Example frontmatter for deprecated doc:**
```yaml
---
status: deprecated
deprecated_date: 2026-01-15
archived_to: notes/archive/2026-01-implementation-tracking.md
reason: "Feature work complete, merged to main"
---
```

### Living → Snapshot

**When:** Major milestone or state transition

**Process:**
1. Copy to dated snapshot
2. Add entry to archive index
3. Continue updating living doc
4. Snapshots provide "state at milestone" reference

## Directory Structure Example

```
your-repo/
├── docs/                           # Durable (stable, long-term)
│   ├── architecture.md
│   ├── guides/
│   └── decisions/
│
├── status/                         # Tracking (working, medium-term)
│   ├── implementation.md
│   ├── gap-analysis.md
│   └── current-state.md
│
├── notes/                          # Ephemeral (draft, short-term)
│   ├── 2026-01-05-exploration.md
│   ├── 2026-01-12-debugging.md
│   └── archive/                    # Archived ephemeral & tracking
│       ├── README.md               # Archive index
│       ├── 2026-01-implementation-tracking.md
│       └── 2026-01-15-pre-merge-state.md
│
├── continue-here.md                # Living (always current)
└── tasks.md                        # Living (active work only)
```

## Configuration in knowledge-base.yaml

Declare temporal layers explicitly:

```yaml
paths:
  docs: docs                        # Durable knowledge
  notes: notes                      # Ephemeral knowledge
  status: status                    # Tracking knowledge (optional)

rules:
  temporal_layers:
    ephemeral:
      path: notes
      retention: "Archive when insights extracted"
      archive_to: notes/archive

    tracking:
      path: status
      retention: "Deprecate when milestone reached"
      archive_to: notes/archive

    durable:
      path: docs
      retention: "Indefinite, update when system changes"
```

## Best Practices

**Start simple:**
- Begin with just docs/ and notes/
- Add status/ only when you have handoff pain or complex tracking needs
- Don't create infrastructure before you need it

**Clear boundaries:**
- Ephemeral: "What am I thinking/learning right now?"
- Tracking: "Where is the work, what's the current state?"
- Durable: "What do we know that should persist?"

**Regular archival:**
- Review notes/ monthly: extract or archive
- Review status/ at milestones: snapshot or deprecate
- Review docs/ on major changes: update or mark deprecated

**Living docs discipline:**
- Only use for truly current-state tracking
- Always snapshot before major transitions
- Document archive policy in frontmatter

## Related Policies

- [Lifecycle policy](lifecycle.md) - Document status progression
- [Authority policy](authority.md) - Distinguishing canonical from working knowledge
- [Provenance policy](provenance.md) - Grounding ephemeral insights in sources

## Examples

See these knowledge bases for temporal layer patterns:
- [Graft implementation](../../graft/) - Uses all three layers (docs/, status/, notes/)
- [Meal planner example](../examples/meal-planner/) - Simple two-layer (docs/, notes/)
