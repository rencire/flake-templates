{
  description = "A collection of flake templates";
  outputs =
    { self }:
    {
      templates = {
        hello = {
          path = ./hello;
          description = "Minimal flake with hello program";
        };
        flakelight-module = {
          path = ./flakelight-module;
          description = "Flake for creating a flakelight module";
        };
        minimal = {
          path = ./minimal;
          description = "A very basic flake with direnv support";
        };
        rust = {
          path = ./rust;
          description = "Flake for rust development";
        };
        tauri = {
          path = ./tauri;
          description = "Flake for creating tauri projects";
        };
      };
      defaultTemplate = self.templates.minimal;
    };
}
