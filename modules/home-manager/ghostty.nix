{pkgs, ...}:
{
  programs = {
    ghostty = {
      enable = true;
      settings = {
        font-feature = [
          "liga"
          "dlig"
          "calt"
          "ss05"
        ];
        font-size = 16;
        font-family = "JetBrainsMono NFM Bold Italic";
        font-thicken = true;
        window-inherit-font-size = true;

        adjust-cursor-thickness = 3;
        adjust-underline-position = 3;

        bold-is-bright = true;

        link-url = true;
        macos-titlebar-proxy-icon = "hidden";
        macos-titlebar-style = "hidden";

        mouse-hide-while-typing = true;
        theme = "Gruvbox Material Dark";
        window-vsync = true;

        background-opacity = 0.95;
        background-blur = true;
        alpha-blending = "native";

        window-decoration = false;
        confirm-close-surface = false;
        # custom-shader = "./assets/shaders/bettercrt.glsl";
      };
    };
  };
}
