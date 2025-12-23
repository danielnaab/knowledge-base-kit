---
title: "Decision 0001: Narrow initial scope"
status: stable
---

# Decision 0001: Narrow initial scope

## Context

We want a narrow initial scope so the tool is deliverable and reliable.

## Decision

Graft starts as:
- configurable tasks/commands (task runner)
- git-centered dependency manager (deps specified via git ref)

## Consequences

- Avoid building a full build system (Bazel/Nix-like) initially.
- Add higher-level workflows later only when needed.

## Sources

- [Interface contract](../interface.md)
