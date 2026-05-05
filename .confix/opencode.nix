# .confix/opencode.nix
{ pkgs, ... }:
{
  mcp = {
    nixos = {
      type = "local";
      enabled = true;
      command = [
        "${pkgs.nix}/bin/nix"
        "run"
        "github:utensils/mcp-nixos"
        "--"
      ];
    };
  };
}
