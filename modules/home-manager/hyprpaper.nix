{pkgs, ...}:
{
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = "false";
        splash_offset = 2.0;
        preload = [
          "~/.config/nixos/assets/wallpapers/wallpaper.jpg"
        ];

        wallpaper = [
        "DP-1, ~/.config/nixos/assets/wallpapers/wallpaper.jpg"
        "HDMI-A-1, ~/.config/nixos/assets/wallpapers/wallpaper.jpg"
        ];
      };
    };
  }
