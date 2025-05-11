{ self, ... }:
{
  imports = [
    self.nvixModules.utils
    self.nvixModules.general
    self.nvixModules.buffer
    self.nvixModules.explorer
    self.nvixModules.colorschemes
    self.nvixModules.snacks
  ];
  colorscheme = "gruvbox"; # as it has light variant also
}
