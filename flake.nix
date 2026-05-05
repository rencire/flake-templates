{
  description = "A collection of flake templates";
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
    { self, flakelight, ... }@inputs:
    let
      agentLib = inputs."agent-skills".lib."agent-skills";
      # Skills are sourced from the personal repo only for now.
      # If we add more sources later, keep skill names unique across them.
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
    (flakelight ./agentic {
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
          bundle = agentLib.mkBundle {
            inherit pkgs selection;
          };
        in
        {
          packages = [
            # We use entire.io to capture agent-assisted code changes
            pkgs.git
            inputs."entire-cli-nix".packages.${pkgs.system}.entire
            pkgs.jj
          ];
          shellHook = agentLib.mkShellHook {
            inherit pkgs bundle;
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
    });
}
