{
  description = "A collection of flake templates";
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
    { self, flakelight, ... }@inputs:
    let
      agentLib = inputs."agent-skills".lib."agent-skills";
      # Skills are sourced from the personal repo only for now.
      # If we add more sources later, keep skill names unique across them.
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
      agenticTemplate = {
        path = ./agentic;
        description = "Flake for local LLM agent workflows with entire";
      };
    in
    (flakelight ./. {
      inherit inputs;
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
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
            # We use entire.io to capture agent-assisted code changes
            inputs."entire-cli-nix".packages.${pkgs.system}.entire
            pkgs'.git
            pkgs'.jujutsu
            configured.opencode
          ];
          shellHook =
            agentLib.mkShellHook {
              pkgs = pkgs';
              inherit bundle;
              targets = localTargets;
            }
            # Optional: uncomment below to specify config for jj
            + ''
              export JJ_CONFIG="$HOME/.config/jj/config-oss.toml"
            '';
        };
      templates = {
        hello = {
          path = ./hello;
          description = "Minimal flake with hello program";
        };
        flakelight-module = {
          path = ./flakelight-module;
          description = "Flake for creating a flakelight module";
        };
        flakelight-package = {
          path = ./flakelight-package;
          description = "Flake for creating a flakelight default package";
        };
        minimal = {
          path = ./minimal;
          description = "A very basic flake with direnv support";
        };
        agentic = agenticTemplate;
        nodejs = {
          path = ./nodejs;
          description = "Flake for nodejs development";
        };
        python = {
          path = ./python;
          description = "Flake for python development";
        };
        rust = {
          path = ./rust;
          description = "Flake for rust development";
        };
        tauri = {
          path = ./tauri;
          description = "Flake for creating tauri projects";
        };
      };
      template = agenticTemplate;
    });
}
