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
      skills = [
        "autoplan"
        "benchmark"
        "benchmark-models"
        "browse"
        "canary"
        "careful"
        "codex"
        "connect-chrome"
        "context-restore"
        "context-save"
        "cso"
        "design-consultation"
        "design-html"
        "design-review"
        "design-shotgun"
        "devex-review"
        "document-release"
        "freeze"
        "gstack-upgrade"
        "guard"
        "health"
        "investigate"
        "land-and-deploy"
        "landing-report"
        "learn"
        "make-pdf"
        "office-hours"
        "open-gstack-browser"
        "openclaw/skills/gstack-openclaw-ceo-review"
        "openclaw/skills/gstack-openclaw-investigate"
        "openclaw/skills/gstack-openclaw-office-hours"
        "openclaw/skills/gstack-openclaw-retro"
        "pair-agent"
        "plan-ceo-review"
        "plan-design-review"
        "plan-devex-review"
        "plan-eng-review"
        "plan-tune"
        "qa"
        "qa-only"
        "retro"
        "review"
        "scrape"
        "setup-browser-cookies"
        "setup-deploy"
        "setup-gbrain"
        "ship"
        "skillify"
        "sync-gbrain"
        "unfreeze"
      ];
    };
  };

  formats = [ "agents" ];
}
