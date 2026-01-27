# Agent entrypoint

This is the agent entrypoint for the meta-knowledge-base repository.

## Quick orientation

- **Configuration**: [knowledge-base.yaml](knowledge-base.yaml)
- **Human entrypoint**: [README.md](README.md)
- **Examples**: [examples/](examples/) (strategy demonstrations)

## Key policies

1. **Authority**: Canonical truth > interpretation > generated > working notes
2. **Provenance**: Ground important claims in sources
3. **Lifecycle**: Use status markers (draft → working → stable → deprecated)
4. **Write boundaries**: Check `rules.writes` in knowledge-base.yaml before editing

## Agent workflow

Use **Plan → Patch → Verify**:

1. **Plan**: State intent, files to touch, uncertainties
2. **Patch**: Smallest diffs that achieve the goal
3. **Verify**: Run checks or specify what human should run

See [Agent workflow playbook](docs/playbooks/agent-workflow.md) for details.

## Write boundaries

This repository allows agent edits to:
- `docs/**` - documentation
- `notes/**` - session logs and explorations
- `examples/**` - example knowledge bases

Do not edit without human review:
- `knowledge-base.yaml` - repository configuration
- Root files - require explicit approval

## Navigation

- Policies: [docs/policies/](docs/policies/)
- Playbooks: [docs/playbooks/](docs/playbooks/)
- Strategies: [docs/strategies/](docs/strategies/)
- Notes: [notes/](notes/)
