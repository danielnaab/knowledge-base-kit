<!-- managed by tuteur: https://github.com/danielnaab/tuteur -->
# Patterns

Each folder here is a git submodule: another repository's pattern, at a release tag. Empty folders?
Run `git submodule update --init --recursive` (or `nix run .#tuteur sync`).

- Read them freely. Ask before you edit one: a fix belongs in the provider. See tuteur's "Fix a provider from
  a consumer" guide: edit on a branch, test, build with it (`nix run .#tuteur -- try NAME`, then `nix run .#tuteur -- try --stop`),
  push to the provider, release, then `nix run .#tuteur upgrade NAME`.
- `nix run .#tuteur check` fails until every pattern is clean and at a release tag, and while try is on.
- Versions: `nix run .#tuteur outdated`.
