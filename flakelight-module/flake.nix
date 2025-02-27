{
  description = "A basic starter flake for creating a flakelight module";
  inputs.flakelight.url = "github:accelbread/flakelight";

  outputs =
    { flakelight, ... }@inputs:
    flakelight ./. {
      inherit inputs;
      imports = [ flakelight.flakelightModules.flakelightModule ];
      flakelightModule = ./flakelight-my-module;
    };
}
