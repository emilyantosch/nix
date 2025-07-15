{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    exec = [
      "exec = gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dracula'"
      "exec = gsettings set org.gnome.desktop.interface gtk-theme 'rose-pine-moon'"
      "exec = gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
    ];

    experimental = {
      "xx_color_management_v4" = "true";
    };

    general = {
      gaps_in = 3;
      gaps_out = 8;
      border_size = 1;
      "col.active_border" = "rgba(282828ff) rgba(ea6962ff) 45deg";
      "col.inactive_border" = "rgba(202020ff) rgba(32302fff) 45deg";
      layout = "dwindle";
      resize_on_border = true;
    };

    group = {
      "col.border_active" = "rgb(ebdbb2) rgb(d65d0e) 60deg";
      "col.border_inactive" = "rgb(272727)";
      "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
      "col.border_locked_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
    };

    decoration = {
      rounding = 10;

      blur = {
        enabled = true;
        size = 3;
        passes = 3;
        new_optimizations = true;
        ignore_opacity = true;
        xray = false;
      };

      shadow = {
        enabled = true;
      };

    };
    windowrule = [
      "float,title:^(Open)$"
      "float,title:^(Choose Files)$"
      "float,title:^(Save As)$"
      "float,title:^(Confirm to replace files)$"
      "float,title:^(File Operation Progress)$"
      "float,class:^(xdg-desktop-portal-gtk)$"
    ];
    layerrule = [
      "blur,rofi"
      "blur, waybar"
    ];
  };
}
