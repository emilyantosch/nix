{ pkgs, lib, ... }:
let
  # Super+V (foreign/niri/config.kdl): open the clipse TUI, or close it if it's
  # already open. The forced title is what the niri window rule floats.
  clipseToggle = pkgs.writeShellApplication {
    name = "clipse-toggle";
    runtimeInputs = [ pkgs.procps pkgs.ghostty pkgs.clipse ];
    text = ''
      pkill -f -- '--title=clipse' && exit 0
      exec ghostty --title=clipse -e clipse
    '';
  };
in
{
  home.packages = [ pkgs.clipse clipseToggle ];

  # Records clipboard history for the TUI: the same two watchers `clipse -listen`
  # forks off (text and images), run under systemd instead so they're tracked
  # and restarted. (-listen-shell is X11/macOS only; on Wayland it just exits.)
  systemd.user.services = lib.genAttrs [ "clipse-text" "clipse-image" ] (name: {
    Unit = {
      Description = "clipse clipboard history listener (${lib.removePrefix "clipse-" name})";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type ${
        if name == "clipse-text" then "text" else "image/png"
      } --watch ${lib.getExe pkgs.clipse} --wl-store";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  });
}
