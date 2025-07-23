{ pkgs, ... }:
{
  programs.vesktop = {
    enable = true;
    vencord = {
      settings.enabledThemes = [ "gruvbox.theme.css" ];
      themes = "../../assets/themes/vesktop/gruvbox.theme.css";
    };
  };
}
