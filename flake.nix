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
    rencire-skills = {
      url = "github:rencire/agent-skills";
      flake = false;
    };
    gstack = {
      url = "github:garrytan/gstack";
      flake = false;
    };
    entire-cli-flake = {
      url = "github:rencire/entire-cli-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flakelight.follows = "flakelight";
      inputs.agent-skills.follows = "agent-skills";
      inputs.rencire-skills.follows = "rencire-skills";
      inputs.llm-agents.follows = "llm-agents";
      inputs.wofr.follows = "wofr";
      inputs.nix-wrapper-modules.follows = "nix-wrapper-modules";
      inputs.confix.follows = "confix";
    };
    wofr = {
      url = "github:rencire/wofr";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flakelight.follows = "flakelight";
      inputs.agent-skills.follows = "agent-skills";
      inputs.personal-skills.follows = "rencire-skills";
      inputs.entire-cli-nix.follows = "entire-cli-flake";
      inputs.llm-agents.follows = "llm-agents";
      inputs.nix-wrapper-modules.follows = "nix-wrapper-modules";
      inputs.confix.follows = "confix";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-wrapper-modules = {
      url = "github:rencire/nix-wrapper-modules/feat/wofr-wrapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    confix = {
      url = "github:rencire/confix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flakelight.follows = "flakelight";
      inputs.nix-wrapper-modules.follows = "nix-wrapper-modules";
    };
  };

  outputs =
    { flakelight, ... }@inputs:
    let
      agenticTemplate = {
        path = ./templates/agentic;
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
      templates = {
        hello = {
          path = ./templates/hello;
          description = "Minimal flake with hello program";
        };
        flakelight-module = {
          path = ./templates/flakelight-module;
          description = "Flake for creating a flakelight module";
        };
        flakelight-package = {
          path = ./templates/flakelight-package;
          description = "Flake for creating a flakelight default package";
        };
        minimal = {
          path = ./templates/minimal;
          description = "A very basic flake with direnv support";
        };
        agentic = agenticTemplate;
        nodejs = {
          path = ./templates/nodejs;
          description = "Flake for nodejs development";
        };
        python = {
          path = ./templates/python;
          description = "Flake for python development";
        };
        rust = {
          path = ./templates/rust;
          description = "Flake for rust development";
        };
        tauri = {
          path = ./templates/tauri;
          description = "Flake for creating tauri projects";
        };
      };
      template = agenticTemplate;
    };
}
