{
  description = "A basic flake for tauri development";
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flakelight.url = "github:accelbread/flakelight";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { flakelight, ... }@inputs:
    flakelight ./. (
      { lib, ... }:
      {
        # Need to inherit this so we can use inputs' later for fenix with the system version
        inherit inputs;
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ];
        withOverlays = [ inputs.fenix.overlays.default ];
        devShell.packages =
          pkgs:
          with pkgs;
          [
            # Add general cross platform tools here
            (inputs'.fenix.packages.complete.withComponents [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
            ])
            rust-analyzer-nightly
            nodejs_20
          ]
          ++ (lib.optionals stdenv.isDarwin [
            # Add macos specific dependencies here
            libiconv
            darwin.apple_sdk.frameworks.Cocoa
            darwin.apple_sdk.frameworks.WebKit
          ]);
      }
    );
}
