{pkgs, ...}:
let
  sddm-candy = pkgs.callPackage ../../packages/nixos/sddm-candy.nix { };
  sddm-corners = pkgs.callPackage ../../packages/nixos/sddm-corners.nix { };
in {
  services.displayManager.sddm = {
    enable = true;
    
    package = pkgs.libsForQt5.sddm;
    extraPackages = with pkgs; [
      sddm-candy
      sddm-corners
      libsForQt5.qt5.qtquickcontrols # for sddm theme ui elements
      libsForQt5.layer-shell-qt # for sddm theme wayland support
      libsForQt5.qt5.qtquickcontrols2 # for sddm theme ui elements
      libsForQt5.qt5.qtgraphicaleffects # for sddm theme effects
      libsForQt5.qtsvg # for sddm theme svg icons
      libsForQt5.qt5.qtwayland # wayland support for qt5
      libsForQt5.qt5.qtbase
    ];

    theme = "Candy";

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
      libsForQt5.qt5.qtquickcontrols # for sddm theme ui elements
      libsForQt5.layer-shell-qt # for sddm theme wayland support
      libsForQt5.qt5.qtquickcontrols2 # for sddm theme ui elements
      libsForQt5.qt5.qtgraphicaleffects # for sddm theme effects
      libsForQt5.qtsvg # for sddm theme svg icons
      libsForQt5.qt5.qtwayland # wayland support for qt5
      libsForQt5.qt5.qtbase

      polkit_gnome # polkit gui
    ];
}
