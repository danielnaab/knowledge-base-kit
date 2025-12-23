# Meta knowledge base (stable entrypoint)

This file is the **only stable entrypoint** downstream knowledge bases should reference.
Everything else in this repository may evolve; links from here will be kept current.

## What this system standardizes

This system does **not** mandate document taxonomies. It standardizes:

- **Entrypoints**: where humans and agents begin
- **Authority**: what counts as canonical truth
- **Provenance**: how to ground important claims in sources
- **Lifecycle**: draft → working → stable → deprecated
- **Strategy**: how to choose an organization approach and evolve it with evidence
- **Linking**: how to keep browser navigation intuitive

## Read next

- [Knowledge organization strategies](strategies/README.md)
- Policies:
  - [Authority](../policies/authority.md)
  - [Provenance](../policies/provenance.md)
  - [Lifecycle](../policies/lifecycle.md)
  - [Linking](../policies/linking.md)
  - [Write boundaries](../policies/writes.md)
  - [Style](../policies/style.md)
- Playbooks:
  - [Choose a strategy](../playbooks/choose-strategy.md)
  - [Evolve a knowledge base](../playbooks/evolve-kb.md)
  - [Agent workflow](../playbooks/agent-workflow.md)

## If you are a downstream repository

Add a `knowledge-base.yaml` at your repo root and include a single link to this entrypoint:

- https://forgejo.example/your-org/meta-knowledge-base/src/branch/main/docs/meta.md

(Your repo’s config can also import this pack; see the examples.)
