{
  config,
  lib,
  flakelight,
  moduleArgs,
  ...
}:
let
  inherit (lib) mkOption mkIf mkMerge;
  inherit (lib.types) lazyAttrsOf;
  inherit (flakelight.types) module nullable optCallWith;
in
{
  options = {
    # Add options here
  };

  config = mkMerge [
    # Add config here
  ];
}
