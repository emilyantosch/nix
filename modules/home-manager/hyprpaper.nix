{pkgs, ...}:
{
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = "false";
        splash_offset = 2.0;
        preload = [
          "~/.config/nixos/assets/wallpapers/Kita.png"
        ];

        wallpaper = [
        "DP-1, ~/.config/nixos/assets/wallpapers/Kita.png"
        "HDMI-A-1, ~/.config/nixos/assets/wallpapers/Kita.png"
        ];
      };
    };
  }
