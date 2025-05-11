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
          "~/.config/nixos/assets/wallpapers/golden_bloom.jpeg"
        ];

        wallpaper = [
        "DP-1, ~/.config/nixos/assets/wallpapers/golden_bloom.jpeg"
        "DP-2, ~/.config/nixos/assets/wallpapers/Kita.png"
        ];
      };
    };
  }
