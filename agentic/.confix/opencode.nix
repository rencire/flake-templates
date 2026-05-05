# .confix/opencode.nix
{ pkgs, ... }:
{
  settings = {
    mcp = {
      nixos = {
        type = "local";
        enabled = true;
        command = [
          "${pkgs.mcp-nixos}/bin/mcp-nixos"
        ];
      };
      # NOTE: This server still needs GITHUB_PERSONAL_ACCESS_TOKEN wired in
      # at runtime later, ideally via sops-nix or another secret manager.
      github = {
        type = "local";
        enabled = true;
        command = [
          "${pkgs.github-mcp-server}/bin/github-mcp-server"
          "stdio"
        ];
        environment = {
          GITHUB_PERSONAL_ACCESS_TOKEN = "<set later>";
        };
      };
    };
  };
}
