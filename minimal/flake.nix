{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flakelight.url = "github:accelbread/flakelight";

  outputs =
    { flakelight, ... }@inputs:
    flakelight ./. {
      inherit inputs;
      devShell = pkgs: {
        packages = with pkgs; [
          #insert packages here
        ];
      };
    };
}
