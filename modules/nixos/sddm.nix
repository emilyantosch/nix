{ pkgs, ... }:
let
  sddm-candy = pkgs.callPackage ../../packages/nixos/sddm-candy.nix { };
  sddm-corners = pkgs.callPackage ../../packages/nixos/sddm-corners.nix { };
in
{
  services.displayManager.sddm = {
    enable = true;

    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      sddm-candy
      sddm-corners
    ];

    wayland = {
      enable = true;
      compositor = "kwin";
    };
    settings = {
      General = {
        GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION = layer-shell";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    sddm-candy
    sddm-corners
  ];
}
