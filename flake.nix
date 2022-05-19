{
  description = "A collection of flake templates";
  outputs = { self }: {
    templates = {
      minimal = {
        path = ./minimal;
        description = "A very basic flake with direnv support";
      };
    };
    defaultTemplate = self.templates.minimal;
  };
}

