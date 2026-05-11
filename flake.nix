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
    { flakelight, ... }@inputs:
    let
      agentSkillsLib = inputs."agent-skills".lib."agent-skills";
      mkAgentBundle =
        pkgs:
        let
          sources = {
            shared = {
              path = inputs."personal-skills";
              subdir = "skills";
            };
          };
        in
        agentSkillsLib.mkBundle {
          inherit pkgs;
          selection = agentSkillsLib.selectSkills {
            catalog = agentSkillsLib.discoverCatalog sources;
            inherit sources;
            allowlist = [
              "dev-loop"
              "doc-table-of-contents"
              "nix-repo"
              "public-repo-readiness"
              "vcs"
            ];
            skills = { };
          };
        };
      localTargets = {
        agents = agentSkillsLib.defaultLocalTargets.agents // {
          enable = true;
        };
        claude = agentSkillsLib.defaultLocalTargets.claude // {
          enable = false;
        };
      };
      agenticTemplate = {
        path = ./agentic;
        description = "Flake for local LLM agent workflows with entire";
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
        default = { pkgs, ... }: mkAgentBundle pkgs;
      };
      devShell =
        pkgs:
        let
          pkgs' = pkgs.extend inputs."llm-agents".overlays.shared-nixpkgs;
          bundle = mkAgentBundle pkgs';
          configured = inputs.confix.lib.configure {
            pkgs = pkgs';
            configDir = ./.confix;
          };
        in
        {
          packages = [
            inputs."entire-cli-nix".packages.${pkgs'.system}.entire
            configured.opencode
            # pkgs'.llm-agents.claude-code
            # pkgs'.llm-agents.codex
            # pkgs'.llm-agents.gemini-cli
            pkgs'.git
          ];
          shellHook = agentSkillsLib.mkShellHook {
            pkgs = pkgs';
            inherit bundle;
            targets = localTargets;
          };
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
    };
}
