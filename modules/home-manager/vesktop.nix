{ pkgs, ... }:
{
  programs.vesktop = {
    enable = true;
    vencord = {
      settings.enabledThemes = [ "gruvbox" ];
      themes = {
        gruvbox = "/home/emmi/.config/nixos/assets/themes/vesktop/gruvbox.theme.css";
      };
    };
  };
}
