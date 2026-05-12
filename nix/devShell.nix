{ inputs, inputs', pkgs, ... }:
let
  agentSkillsLib = inputs."agent-skills".lib."agent-skills";
  agentBundle = import ./agent-bundle.nix {
    inherit agentSkillsLib;
    personalSkills = inputs."personal-skills";
  };
  pkgs' = (pkgs.extend inputs."llm-agents".overlays.shared-nixpkgs).extend (
    _: prev: {
      wofr = inputs'.wofr.packages.default;
      entire = inputs'."entire-cli-nix".packages.default;
    }
  );
  configured = inputs.confix.lib.configure {
    pkgs = pkgs';
    configDir = ./confix;
  };
in
{
  packages = [
    pkgs'.git
    pkgs'.entire
    configured.opencode
    configured.wofr
    # pkgs'.llm-agents.claude-code
    # pkgs'.llm-agents.codex
    # pkgs'.llm-agents.gemini-cli
  ];
  shellHook = agentSkillsLib.mkShellHook {
    pkgs = pkgs';
    bundle = agentBundle.bundle pkgs';
    targets = agentBundle.targets;
  };
}
