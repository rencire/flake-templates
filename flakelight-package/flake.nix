{
  description = "Flake for creating a flakelight default package";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flakelight.url = "github:accelbread/flakelight";

  outputs =
    { flakelight, ... }@inputs:
    flakelight ./. {
      inherit inputs;
    };
}
