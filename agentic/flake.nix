{
  description = "A flake for local LLM agent workflows";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flakelight = {
      url = "github:accelbread/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    personal-skills = {
      url = "github:rencire/agent-skills";
      flake = false;
    };
    entire-cli-nix = {
      url = "github:rencire/entire-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    confix = {
      url = "github:rencire/confix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { flakelight, ... }@inputs:
    let
      agentLib = inputs."agent-skills".lib."agent-skills";
      personalSkills = if inputs ? "personal-skills" then inputs."personal-skills" else null;
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
        "dev-loop"
        "doc-table-of-contents"
        "nix-repo"
        "public-repo-readiness"
        "vcs"
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
        gemini = agentLib.defaultLocalTargets.gemini // {
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
          pkgs' = pkgs.extend inputs."llm-agents".overlays.shared-nixpkgs;
          bundle = agentLib.mkBundle {
            pkgs = pkgs';
            inherit selection;
          };
          configured = inputs.confix.lib.configure {
            pkgs = pkgs';
            configDir = ./.confix;
          };
        in
        {
          packages = [
            inputs."entire-cli-nix".packages.${pkgs'.system}.entire
            configured.opencode
            pkgs'.git
            pkgs'.jj
          ];
          shellHook =
            agentLib.mkShellHook {
              pkgs = pkgs';
              inherit bundle;
              targets = localTargets;
            }
            # Optional: uncomment below to specify config for jj
            + ''
              # export JJ_CONFIG="$HOME/.config/jj/config-oss.toml"
            '';
        };
    };
}
