{pkgs, user, ...}:
{
  environment.systemPackages = [
    pkgs.kanata
  ];

  launchd = {
    daemons = {
      kanata = {
        command = "${pkgs.kanata}/bin/kanata -c ${./kbd_macos.kbd}";
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/kanata.out.log";
          StandardErrorPath = "/tmp/kanata.err.log";
        };
      };
    };
  };
}
