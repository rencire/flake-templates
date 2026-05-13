{
  skillSets = {
    rencire = {
      input = "rencire-skills";
      subdir = "skills";
      prefix = "rencire";
      skills = [
        "dev-loop"
        "doc-table-of-contents"
        "nix-repo"
        "public-repo-readiness"
        "vcs"
      ];
    };
    gstack = {
      input = "gstack";
      subdir = ".";
      filter.maxDepth = 1;
      prefix = "gstack";
      skills = [ "review" ];
    };
  };

  formats = [ "agents" ];
}
