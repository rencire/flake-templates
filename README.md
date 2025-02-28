# Flake Templates

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
- Each template is [`direnv`](https://github.com/direnv/direnv)-aware
