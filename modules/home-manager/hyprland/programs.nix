{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "alacritty";
    "$fileManager" = "nautilus";
    "$run-menu" = "rofi -show drun";
    "$file-menu" = "rofi -show window";
    "$window-menu" = "rofi -show filebrowser";
    "$browser" = "zen";
    "$notes" = "obsidian";
  };
}
