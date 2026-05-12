{
  description = "A basic starter flake for creating a flakelight module";
  inputs.flakelight.url = "github:accelbread/flakelight";

  outputs =
    { flakelight, ... }:
    flakelight ./. {
      imports = [ flakelight.flakelightModules.flakelightModule ];
      flakelightModule = ./flakelight-my-module.nix;
    };
}
