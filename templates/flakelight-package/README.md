# Note
To expose a default package, create a `_default.nix`.

e.g.
```
packages/
├── _default.nix  # This becomes packages.${system}.default
  
```

e.g. packages/_default.nix
```nix
{
  lib,
  rustPlatform,
  ...
}
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zed-editor-latest";
  version = "0.190.3";
  # Rest of package definition
  ...
}

```
