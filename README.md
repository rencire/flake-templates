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

## Notes
- Most (if not all) templates leverage the [`flakelight`](https://github.com/nix-community/flakelight) framework.
- Each template is [`direnv`](https://github.com/direnv/direnv)-aware
