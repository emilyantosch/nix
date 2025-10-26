{
  flake,
  inputs',
  self',
  ...
}:
let
  inherit (flake) inputs self;
  bareModules = [
    # Core functionality and improvements
    self.darwinPlugins.common
  ];
  homeModules = bareModules ++ [
  ];
  moiaModules = bareModules ++ [
  ];
in
{
  packages = {
    default = self'.packages.core;
    bare = bareModules;
    home = homeModules;
    moia = moiaModules;
  };
}
