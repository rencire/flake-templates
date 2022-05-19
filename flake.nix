{
  description = "A collection of flake templates";
  outputs = { self }: {
    templates = {
      hello = {
        path = ./hello;
        description = "Minimal flake with hello program";
      };
      minimal = {
        path = ./minimal;
        description = "A very basic flake with direnv support";
      };
    };
    defaultTemplate = self.templates.minimal;
  };
}

