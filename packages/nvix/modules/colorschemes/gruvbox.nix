{ config, ... }:
{
  colorschemes.gruvbox = {
    enable = true;
    settings = {
      terminal_colors = true;
      transparent_mode = config.nvix.transparent;
      undercurl = true;
      underline = true;
      bold = true;
      contrast = "hard";
    };
  };
}
