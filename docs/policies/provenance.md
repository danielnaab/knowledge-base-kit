---
status: stable
---
# Provenance policy

When a claim matters, show where it came from.

## When required
- operational guidance
- factual claims that drive decisions
- syntheses explaining system behavior

## Preferred references
- file + heading anchor
- file + stable symbol name

## Where provenance should appear
Use a dedicated `## Sources` section whenever possible.

## Example Sources section

```markdown
## Sources
- [Authority policy](policies/authority.md#conflict-resolution)
- [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119) - requirement level keywords
```

## Structured provenance (optional)

Where tools or agents read provenance, it may live in frontmatter instead. It counts the same as a
`## Sources` section; use one or the other in a document, not both.

- `sources` lists what the document derives from. Each entry has a `resource` (URL or path) and,
  when the body cites it, a stable `id`.
- A claim cites a source with a footnote labelled with that `id`, so citations survive reordering.
- This is [OKF v0.2](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
  provenance (§5.1); it can be adopted without the rest of OKF.

```markdown
---
sources:
  - id: rfc2119
    resource: https://datatracker.ietf.org/doc/html/rfc2119
---
Requirement keywords follow RFC 2119.[^rfc2119]

[^rfc2119]: RFC 2119
```

Related:
- [Authority policy](authority.md)
- [Linking policy](linking.md)
