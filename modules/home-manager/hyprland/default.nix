{
  config,
  pkgs,
  inputs,
  lib,
}:
{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.plugins = with pkgs; [
    (callPackage ./../../../packages/hyprland-plugins/default.nix { }).hyprsplit
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
