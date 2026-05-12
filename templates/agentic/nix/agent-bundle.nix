{
  agentSkillsLib,
  inputs,
}:
let
  sources = {
    rencire = {
      path = inputs."personal-skills";
      subdir = "skills";
      idPrefix = "rencire";
    };
    gstack = {
      path = inputs.gstack;
      subdir = ".";
      idPrefix = "gstack";
      filter.maxDepth = 1;
    };
  };
  catalog = agentSkillsLib.discoverCatalog sources;
  allowlist = agentSkillsLib.allowlistFor {
    inherit catalog sources;
    enable = [
      "rencire/dev-loop"
      "rencire/doc-table-of-contents"
      "rencire/nix-repo"
      "rencire/public-repo-readiness"
      "rencire/vcs"
      "gstack/gstack"
      "gstack/review"
    ];
  };
  bundle =
    pkgs:
    agentSkillsLib.mkBundle {
      inherit pkgs;
      selection = agentSkillsLib.selectSkills {
        inherit catalog sources allowlist;
        skills = { };
      };
    };
  targets = {
    agents = agentSkillsLib.defaultLocalTargets.agents // {
      enable = true;
    };
    claude = agentSkillsLib.defaultLocalTargets.claude // {
      enable = false;
    };
  };
in
{
  inherit bundle targets;
}
