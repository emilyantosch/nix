{pkgs, ...}:
{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.plugins = [
    pkgs.hyprlandPlugins.hyprsplit
  ];
  imports = [
    ./animations.nix 
    ./autostart.nix
    ./bind.nix
    ./env.nix
    ./monitor.nix
    ./nvidia.nix 
    ./programs.nix
    ./theme.nix
    ./windowrules.nix
    ./keyboard.nix
  ];
}
