# Notes

- This template installs local agent skills into common harness targets on
  `nix develop`.
- Installed skills are namespaced by source so bundles can compose cleanly, for
  example `rencire/dev-loop`.
- Run `nix run .#entire-init` after `nix develop` to let Entire install hooks
  and enable the configured agents.
- `nix run .#entire-init` creates repo config like `.entire/` and agent-specific
  config directories such as `.opencode/`; commit those in the generated
  project.
