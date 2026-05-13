{ pkgs, inputs }:
{
  gstack-init = import ./apps/gstack-init.nix { inherit pkgs inputs; };
}
