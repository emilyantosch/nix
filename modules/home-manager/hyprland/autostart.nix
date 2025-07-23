{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "clipse -listen"
      "swww-daemon"
    ];
  };
}
