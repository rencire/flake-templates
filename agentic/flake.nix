{
  description = "A flake for local LLM agent workflows";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flakelight = {
    url = "github:accelbread/flakelight";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.agent-skills = {
    url = "github:Kyure-A/agent-skills-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs."personal-skills" = {
    url = "github:rencire/agent-skills";
    flake = false;
  };
  inputs.entire-cli-nix = {
    url = "github:rencire/entire-cli-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { flakelight, ... }@inputs:
    let
      agentLib = inputs."agent-skills".lib."agent-skills";
      personalSkills =
        if inputs ? "personal-skills" then
          inputs."personal-skills"
        else
          null;
      sources =
        if personalSkills == null then
          { }
        else
          {
            shared = {
              path = personalSkills;
              subdir = "skills";
            };
          };
      enabledSkills = [
        # Add skills here
      ];
      catalog = agentLib.discoverCatalog sources;
      allowlist = agentLib.allowlistFor {
        inherit catalog sources;
        enable = enabledSkills;
      };
      selection = agentLib.selectSkills {
        inherit catalog allowlist sources;
        skills = { };
      };
      localTargets = {
        agents = agentLib.defaultLocalTargets.agents // {
          enable = true;
        };
        claude = agentLib.defaultLocalTargets.claude // {
          enable = true;
        };
        codex = agentLib.defaultLocalTargets.codex // {
          enable = true;
        };
        opencode = agentLib.defaultLocalTargets.agents // {
          dest = ".opencode/skills";
          enable = true;
        };
      };
    in
    flakelight ./. {
      inherit inputs;
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      packages = {
        default =
          { pkgs, ... }:
          agentLib.mkBundle {
            inherit pkgs selection;
          };
      };
      devShell =
        pkgs:
        let
          bundle = agentLib.mkBundle {
            inherit pkgs selection;
          };
        in
        {
          packages = [
            inputs."entire-cli-nix".packages.${pkgs.system}.entire
          ];
          shellHook = agentLib.mkShellHook {
            inherit pkgs bundle;
            targets = localTargets;
          };
        };
    };
}
