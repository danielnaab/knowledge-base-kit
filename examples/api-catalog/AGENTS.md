# Agent entrypoint (API catalog example)

Before making changes, read:
- [Domain knowledge-base.yaml](knowledge-base.yaml)
- [Meta knowledge base entrypoint](https://forgejo.example/your-org/meta-knowledge-base/src/branch/main/docs/meta.md)

Strategy: **Metadata + generated views** - items with frontmatter, queryable index.

Rules of thumb:
- Every API doc must have frontmatter with `status` and `tags`
- Update [apis/index.md](apis/index.md) when adding or changing API status
- Use consistent tag vocabulary from knowledge-base.yaml
- Mark deprecated APIs clearly before removal

Helpful:
- [Plan -> Patch -> Verify](../../docs/playbooks/agent-workflow.md)
