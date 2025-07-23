{ pkgs, ... }:
{
  programs.vesktop = {
    enable = true;
    vencord = {
      settings.enabledThemes = [ "gruvbox" ];
      themes = {
        gruvbox = "../../assets/themes/vesktop/gruvbox.theme.css";
      };
    };
  };
}
