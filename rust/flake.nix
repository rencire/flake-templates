{
  description = "A basic flake for rust development";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flakelight.url = "github:accelbread/flakelight";
  # For nightly rust
  inputs.fenix = {
    url = "github:nix-community/fenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  # For incremental crate builds and caching during development
  inputs.crane.url = "github:ipetkov/crane";

  outputs =
    {
      flakelight,
      fenix,
      crane,
      ...
    }@inputs:
    flakelight ./. {
      inherit inputs;
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      withOverlays = [ fenix.overlays.default ];
      # Define the package
      packages = {
        default =
          { pkgs, ... }:
          let
            rustToolchain = (
              fenix.packages.${pkgs.system}.minimal.withComponents [
                "cargo"
                "rustc"
              ]
            );
            craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;
            cargoArtifacts = craneLib.buildDepsOnly {
              src = ./.;
              pname = "my-app-deps";
              version = "0.1.0";
            };
          in
          craneLib.buildPackage {
            inherit cargoArtifacts;
            src = ./.;
            pname = "my-app";
            version = "0.1.0";
          };
      };
      # Expose as runnable app
      # Notes: We can grab my-app package from `pkgs` here, because flakelight automatically added it to
      # overlays.default.  Even for default package, it seems to grab the name from `pname`?
      apps = {
        default =
          { my-app, ... }:
          {
            type = "app";
            program = "${my-app}/bin/my-app";
          };
      };
      devShell = pkgs: {
        packages =
          with pkgs;
          let
            rustToolchain = (
              fenix.packages.${pkgs.system}.complete.withComponents [
                "cargo"
                "clippy"
                "rust-src"
                "rustc"
                "rustfmt"
              ]
            );
          in
          [
            rustToolchain
            rust-analyzer-nightly
          ];
      };
    };
}
