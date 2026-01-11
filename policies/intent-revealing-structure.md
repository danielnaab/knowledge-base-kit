# Intent-revealing structure policy

File and directory names should communicate purpose without opening files.

## Why this matters

Navigation pain often stems from opaque names. When structure reveals intent, readers find information faster and understand the system's purpose at a glance.

## File naming

Name files to reveal their content:

Correct:
- `macos-user-accounts.md` (describes work/personal separation approach)
- `secrets-management.md` (explains password management tiers)
- `backup-recovery.md` (documents backup strategy)

Incorrect:
- `decision-0003.md` (reveals nothing about content)
- `doc-v2.md` (version numbers hide purpose)
- `misc-notes.md` (catch-all names force opening to understand)

## Directory naming

Name directories to reveal their purpose:

Correct:
- `device-configuration/` (how devices are configured)
- `integrations/` (how system connects to others)
- `decisions/` (architectural decisions)

Incorrect:
- `docs/` (too generic when multiple doc types exist)
- `old/` (temporal marker, not purpose)
- `part-2/` (sequence, not intent)

## Structure as documentation

Directory structure should reveal system architecture:

Correct:
```
architecture/
├── device-configuration/     # Clear: device setup
│   ├── nix-darwin.md
│   └── macos-accounts.md
└── integrations/             # Clear: external connections
    ├── homelab-access.md
    └── ios-workflows.md
```

Incorrect:
```
architecture/
├── section-1.md              # Opaque: what's in section 1?
├── section-2.md
└── notes/                    # Vague: what kind of notes?
```

## When to apply

Use intent-revealing names when:
- A repository grows beyond 5-10 files
- Multiple people (or agents) navigate the knowledge base
- You observe "where is X?" questions repeatedly

## Trade-offs

Accepts:
- Longer file names (more descriptive)
- Occasional file renames when purpose shifts

Gains:
- Faster navigation (grep by purpose, not number)
- Self-documenting structure (README unnecessary for navigation)
- Clearer handoffs (new collaborators understand layout)

## Relation to other policies

This policy addresses **navigation pain** (from [evolve-kb playbook](../playbooks/evolve-kb.md)) at the structural level. It complements:
- [Linking policy](linking.md) - how to connect documents
- [Authority policy](authority.md) - which documents are canonical
- [Temporal layers](temporal-layers.md) - lifecycle-based organization

Related:
- [Playbook: evolve a knowledge base](../playbooks/evolve-kb.md)
- [Style policy](style.md)
