{pkgs, ...}:
{
  programs.rofi = {
    extraConfig = {
      modi = "drun";
      show-icons = true;
      drun-display-format = "{name}";
      font = "JetBrainsMono Nerd Font 10";

      sort = true;
      kb-cancel = "Escape,Super+Space";
    };
  };
}
