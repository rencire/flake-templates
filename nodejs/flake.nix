{
  description = "A flake with a nodejs";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in with pkgs; {
      devShell = mkShell {
        nativeBuildInputs = [ bashInteractive ];
        buildInputs = [ nodejs ];
      };
    });
}
