{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url =  "github:NixOS/nixpkgs/nixpkgs-unstable";
  flakelight.url = "github:accelbread/flakelight";

  outputs = { flakelight, ... }@inputs:
    flakelight ./. {
      inherit inputs;
      devShell = pkgs: {
        packages = with pkgs; [ git ]; 
      };
    };
}
