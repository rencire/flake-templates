# Notes

- This template installs local agent skills into common harness targets on
  `nix develop`.
- Installed skills are namespaced by source so bundles can compose cleanly,
  for example `rencire/dev-loop` and `gstack/review`.
- Agent enablement is driven by `entireConfig` in `flake.nix`.
- Run `entire-init` after `nix develop` to let Entire install hooks and enable
  the configured agents.
- `entire-init` creates repo config like `.entire/` and agent-specific config
  directories such as `.opencode/`; commit those in the generated project.
- Set `entireConfig.checkpointRemote` in `flake.nix` if you want the template to
  write a committed `.entire/settings.json` before enabling agents.
