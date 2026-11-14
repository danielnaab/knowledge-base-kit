---
status: stable
---
# Linking policy

Links exist to improve navigation and trust, especially when browsing in Forgejo/GitHub.

## Navigation links (required)
If a reader should click something, use a real Markdown link.

Correct:
- [Meta knowledge base](../../README.md)

Incorrect:
- `../../README.md`

Write link text that says where the link goes ("the [lifecycle policy](lifecycle.md)"), not "here".

## Provenance links
In a `## Sources` section, use real links whenever possible.

## Exported files
A repository that others graft is read in their `scions/` folder: with graft v2.13.0 or later the whole
repository at a release tag, a git submodule, but without its own scions (git does not fill a submodule's
submodules). A file others read links only to files they have: a link into your `scions/` works in your
repository and breaks in every consumer's. Link to such a file by URL, at the tag you pin rather than `main`,
and update the tag when you upgrade. Files only you read (AGENTS.md) may link into your `scions/`.
If you also ship a `git archive` export (`.gitattributes` `export-ignore`), its files link only to exported
files, by the same rule.

## Backticks are for literal text
- paths and globs being discussed as text (`docs/**`)
- commands, flags, keys, environment variables and identifiers the reader types or sees
- code snippets

Related:
- [Provenance policy](provenance.md)
- [Style policy](style.md)
- [Managing KB dependencies](../playbooks/manage-kb-dependencies.md#provide-one)
