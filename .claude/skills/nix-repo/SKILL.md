---
name: nix-repo
description: "Use for implementation work in Nix-managed repos: read the local repo docs first, run commands through nix develop, and keep Nix-specific environment guidance separate from the generic dev loop."
---

# Nix Repo

Use this skill for repo-local implementation work in a Nix-based project.

## Workflow

1. Read the repo's local guidance first, especially `AGENTS.md` and any
   workflow doc it points to.
2. Run project commands through `nix develop -c ...` so you work inside the
   repo's declared environment.
3. If a required tool is missing from the shell, propose adding it to
   `flake.nix` and get approval before expanding the dev environment.
4. Use the generic `dev-loop` skill for the implementation workflow itself.

## Guardrails

- Do not expand the dev shell without approval.
