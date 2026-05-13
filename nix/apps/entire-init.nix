{ pkgs, inputs, ... }:
let
  inherit (pkgs) lib;
  system = pkgs.stdenv.hostPlatform.system;
  cfg = import ../config/entire-init-config.nix;
  entire = inputs."entire-cli-flake".packages.${system}.default;
  script = pkgs.writeShellScript "entire-init" ''
    set -euo pipefail
    export PATH="${lib.makeBinPath [ entire ]}:$PATH"
    ${if cfg.enable then ''
      echo "-> Enabling entire in project..."
      entire enable --project -y \
        --checkpoint-remote "${cfg.checkpoint_remote.provider}:${cfg.checkpoint_remote.repo}"

      ${lib.concatStringsSep "\n" (map (agent: ''
        echo "-> Adding agent ${agent}..."
        entire agent add "${agent}"
      '') cfg.agents)}

      echo "entire-init complete"
    '' else ''
      echo "-> Disabling entire in project..."
      entire disable --project
      echo "entire-init complete (disabled)"
    ''}
  '';
in
{
  type = "app";
  program = "${script}";
}
