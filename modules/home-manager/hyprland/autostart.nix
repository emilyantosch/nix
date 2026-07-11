{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "clipse -listen"
      "awww-daemon"
    ];
  };
}
