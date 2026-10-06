{ pkgs, inputs, ... }:
let
  caelestia-shell = inputs.qs-caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.file.".config/caelestia/shell.json".source = ../../foreign/caelestia/shell.json;
  home.file.".config/caelestia/cli.json".source = ../../foreign/caelestia/cli.json;

  # Run the shell under systemd so it comes back if Qt Wayland segfaults
  # when outputs flap during lock/sleep.
  systemd.user.services.caelestia-shell = {
    Unit = {
      Description = "Caelestia shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${caelestia-shell}/bin/caelestia-shell";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
