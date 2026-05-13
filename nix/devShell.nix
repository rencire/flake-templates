{ inputs, inputs', pkgs, ... }:
let
  agentSkillsLib = inputs."agent-skills".lib."agent-skills";
  agentSkillsConfig = import ./config/agent-skills-config.nix;
  agentBundle = import ./lib/agent-bundle.nix {
    inherit agentSkillsLib inputs;
    lib = pkgs.lib;
    inherit (agentSkillsConfig) skillSets formats;
  };
  pkgs' = (pkgs.extend inputs."llm-agents".overlays.shared-nixpkgs).extend (
    _: prev: {
      wofr = inputs'.wofr.packages.default;
      entire = inputs'."entire-cli-flake".packages.default;
    }
  );
  configured = inputs.confix.lib.configure {
    pkgs = pkgs';
    configDir = ./confix;
  };
in
{
  packages = [
    pkgs'.bun
    pkgs'.git
    pkgs'.entire
    configured.opencode
    configured.wofr
    # pkgs'.llm-agents.claude-code
    # pkgs'.llm-agents.codex
    # pkgs'.llm-agents.gemini-cli
  ];
  env.GSTACK_HOME = ".gstack";
  shellHook = agentSkillsLib.mkShellHook {
    pkgs = pkgs';
    bundle = agentBundle.bundle pkgs';
    targets = agentBundle.targets;
  };
}
