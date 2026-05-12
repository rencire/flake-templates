# Flake Templates
## About
This is my personal collection of flake templates.

## Usage
Examples:

Initialize new flake project folder with "minimal" template:
```
nix flake new -t github:rencire/flake-templates/main#minimal my_project
```

Add flake template to existing project folder:
```
cd my_project
nix flake init -t github:rencire/flake-templates/main#minimal
```

Initialize new flake project folder with the agent-enabled "agentic" template:
```
nix flake new -t github:rencire/flake-templates/main#agentic my_agentic_project
```

Then bootstrap Entire in the generated project:
```
cd my_agentic_project
nix develop
entire-init
```

This writes Entire and agent config into the repo, such as `.entire/` and
`.opencode/`, which should then be committed in the generated project.

The agentic template also installs a small, prefixed skill bundle on
`nix develop`, including `rencire/...` skills from
`github:rencire/agent-skills` and selected `gstack/...` skills from
`github:garrytan/gstack`.

## Notes
- Most (if not all) templates leverage the [`flakelight`](https://github.com/nix-community/flakelight) framework.
- Each template is [`direnv`](https://github.com/direnv/direnv)-aware
