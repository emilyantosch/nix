{
  self,
  ...
}:
let
  bareModules = [
    # Core functionality and improvements
    self.darwinPlugins.aerospace
    self.darwinPlugins.homebrew
    self.darwinPlugins.jankyborders
    self.darwinPlugins.darwin-system
  ];
  homeModules = bareModules ++ [
  ];
  moiaModules = bareModules ++ [
  ];
in
{
  darwinModules = {
    aerospace = self.darwinPlugins.aerospace;
  };
}
