# .confix/opencode.nix
{ pkgs, ... }:
{
  settings = {
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
  };
}
