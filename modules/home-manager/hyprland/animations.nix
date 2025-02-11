{...}:
{
  wayland.windowManager.hyprland.settings = {
    layerrule = [
      "noanim, hyprpicker"
      "noanim, selection"
    ];
  };
  imports = [
    ./animations/diablo.nix
  ];
}
