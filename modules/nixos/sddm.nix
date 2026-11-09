{ pkgs, inputs, ... }:
let
  sddm-candy = pkgs.callPackage ../../packages/nixos/sddm-candy.nix { };
  sddm-corners = pkgs.callPackage ../../packages/nixos/sddm-corners.nix { };

  # Active qylock theme: an upstream name, or "<dir>-custom" for an edited
  # copy under assets/qylock/<dir>/.
  qylockTheme = "girl-coffee-custom";
  qylock-custom-themes =
    pkgs.callPackage ../../packages/nixos/qylock-custom-themes.nix { };
  # Upstream's qylock-lock only searches its own themes dir, so build it with
  # the custom themes copied in alongside.
  qylock-lock =
    (inputs.qylock.legacyPackages.${pkgs.stdenv.hostPlatform.system}.mkQuickshell {
      defaultTheme = qylockTheme;
    }).overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        cp -r ${qylock-custom-themes}/share/sddm/themes/. $out/share/qylock/themes/
      '';
    });
in {
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = [ sddm-candy sddm-corners qylock-custom-themes ];

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
  # qylock: SDDM login themes + Quickshell lockscreen (`qylock-lock`).
  # Sets services.displayManager.sddm.theme and adds the themes' QML deps.
  programs.qylock = {
    enable = true;
    theme = qylockTheme;
    # Replaced by the qylock-lock built above (includes custom themes).
    quickshell.enable = false;
  };

  environment.systemPackages = with pkgs; [
    sddm-candy
    sddm-corners
    qylock-custom-themes
    qylock-lock
    # Video backgrounds in the qylock themes need these.
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];
}
