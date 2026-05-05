---
name: public-repo-readiness
description: Use before pushing when you need to review tracked files, untracked files, and repo metadata for secrets, machine-specific details, or other publication risks.
---

# Public Repo Readiness

Use this skill before pushing when the current change may contain secrets, machine-local details, or other content that should not leave the local repo.

## What To Check

- tracked files and docs that could contain credentials or sensitive operational details
- ignore rules for local runtime data, environment files, and certificate material
- repo metadata and docs that may have machine-specific paths or local-only hostnames
- pending untracked files that might be added accidentally during the publishing flow

## Workflow

1. Run the review from inside the Nix shell with `nix develop -c ...` so the scan uses the repo's declared tools.
2. Inspect the exact tracked change set with `jj status`, `jj diff`, or equivalent read-only Git commands before staging or pushing.
3. Scan tracked files with `git ls-files` and `rg` patterns such as `token`, `secret`, `password`, `BEGIN .* PRIVATE KEY`, provider API key prefixes, and connection strings.
4. Search for machine-local details that do not belong in published history, especially absolute home-directory paths and local-only hostnames.
5. Confirm `.gitignore` still excludes local databases, `.env` files, certificate material, and other scratch artifacts produced during development.
6. Review untracked files before staging anything, and do not add local data just because it is nearby.
7. If a real credential is found, rotate it outside the repo, remove it from the pending change or history as needed, and only then continue.
8. Record durable guidance in repo docs when the scan turns up a recurring class of problem.

## Guardrails

- Treat token-like values as suspicious until proven otherwise.
- Prefer removing machine-specific detail even when it is not strictly secret.
- Do not push until the review passes cleanly.
- If this scan becomes routine, prefer replacing manual checks with a deterministic script or CI check.
