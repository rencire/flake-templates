# Notes

- This template installs local agent skills into common harness targets on
  `nix develop`.
- Installed skills are namespaced by source so bundles can compose cleanly, for
  example `rencire/dev-loop`.
- Run `nix run .#setup-entire` and `nix run .#setup-gstack` after generating
  this project to bootstrap your AI agent tooling. These are one-shot setup
  commands — commit the generated files after running them.

## `nix run .#setup-entire`

Writes `.entire/settings.json` from `nix/config/setup-entire-config.nix`, then
calls `entire enable -y` and `entire agent add` for each configured agent.

What it creates:
- `.entire/settings.json` — entire project config (checkpoint remote, telemetry)
- `.entire/.gitignore` — keeps session data out of version control
- Git hooks (`prepare-commit-msg`, `commit-msg`, `post-commit`, `pre-push`) —
  core session tracking that captures prompts, responses, and files touched
- Orphan branch `entire/checkpoints/v1` — session metadata that never pollutes
  your main branch
- Search subagents for Claude Code and Gemini — lets each agent query entire
  history
- Agent-specific config dirs (`.opencode/`, etc.)

Configure agents and checkpoint remote in
`nix/config/setup-entire-config.nix`.

To disable: set `enable = false` in the config, then run the app again to call
`entire disable --project`.

## `nix run .#setup-gstack`

Copies gstack from the Nix store to `.gstack/repos/gstack`, then runs gstack's
`./setup` script for each configured host and agent.

What it creates:
- `.gstack/repos/gstack/` — local copy of the gstack repo with compiled
  binaries (browse, design, make-pdf, etc.)
- Symlinks to agent skill directories (`~/.claude/skills/gstack/`,
  `~/.config/opencode/skills/gstack/`) — one per host in `extraHosts`
- Skills prefixed with `gstack-*` for namespace clarity (e.g., `gstack-review`,
  `gstack-investigate`)
- Team enforcement hooks (`.claude/hooks/check-gstack.sh`) when
  `team.mode = "required"` — prevents Skill use without gstack installed
- Updates CLAUDE.md with a `## gstack (REQUIRED)` section

Configure hosts and team mode in
`nix/config/setup-gstack-config.nix`.

Idempotent: safe to re-run. Only copies gstack from the Nix store if
`.gstack/repos/gstack/` doesn't already exist.
