# Agent entrypoint

This is the agent entrypoint for knowledge-base-kit: conventions for knowledge bases (`docs/`), and the checker
that enforces them (`src/`, specified in `specs/`).

## Quick orientation

- **Configuration**: [knowledge-base.yaml](knowledge-base.yaml)
- **Human entrypoint**: [README.md](README.md)
- **Conventions**: [policies](docs/policies/), [playbooks](docs/playbooks/), [strategies](docs/strategies/)
- **Checker**: [usage](docs/tools.md), [specs](specs/README.md), code in `src/`, tests in `tests/`
- **Examples**: [examples/](examples/) (strategy demonstrations)
- **Grafted**: [living specifications](scions/living-specifications/README.md), the methodology the
  specs and the backlink scanner follow

## Key policies

1. **Authority**: canonical truth > interpretation > generated > working notes. `docs/` is canonical for the
   conventions, `specs/` for the checker's behavior.
2. **Provenance**: ground important claims in sources
3. **Lifecycle**: status markers (draft → working → stable → deprecated; `living` for always-current documents)
4. **Write boundaries**: check `rules.writes` in knowledge-base.yaml before editing
5. **One owner per rule**: a convention changes in `docs/` and the checker together. The checker enforces rules;
   it doesn't define them. Its specs cite the policy each check implements.
6. **What consumers get**: the whole repository at a release tag, as a git submodule (graft v2.13.0), without
   its own `scions/`; [graft.nix](graft.nix) wires the checker's tools and check into their flake. Files they
   read link by URL into `scions/` ([Linking policy](docs/policies/linking.md#exported-files)).

## Agent workflow

Use **Plan → Patch → Verify** (see [Agent workflow playbook](docs/playbooks/agent-workflow.md)):

1. **Plan**: state intent, files to touch, uncertainties
2. **Patch**: smallest diffs that achieve the goal. For the checker: spec first, then a failing test, then code.
3. **Verify**: `uv run pytest`, `uv run ruff check src tests`, then dogfood: `uv run link-validator`,
   `uv run kb-linter`, `uv run backlink-scanner`; `nix flake check` for the tools, `graft.nix`'s contract test
   and the kit's own docs (`checks.<system>.kb`).

## Write boundaries

Agents may edit `docs/**`, `notes/**`, `examples/**`, `specs/**`, `src/**`, `tests/**`.
Ask before editing `knowledge-base.yaml` and root files. Ask before editing a scion in `scions/` (git submodules
at release tags): a fix belongs in the provider, made on a branch in the scion, released, then taken with
`nix run .#graft upgrade` (`.claude/settings.json` asks for Claude Code). Never edit `secrets/**` or
`credentials/**`.

## Checker architecture

```
tool_cli (shared CLI runner)
   ├── backlink_scanner (spec traceability)
   ├── kb_linter (content validation)
   └── link_validator (link checking)
```

Each tool provides `runner(root_dir)`, `serializer(result)` and `has_failures(result)`. Runtime is the Python
standard library only.
