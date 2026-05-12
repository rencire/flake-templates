{ pkgs, ... }:
{
  package = pkgs.wofr;
  settings = {
    entire = {
      agents = [ "opencode" ];
      checkpoint_remote = {
        provider = "github";
        repo = "<owner>/<repo>";
      };
    };
  };
}
