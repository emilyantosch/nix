{pkgs, ...}:
{
  environment.systempackages = [
    pkgs.kanata
  ];

  launchd = {
    daemons = {
      kanata = {
        command = "${pkgs.kanata}/bin/kanata -c ${./../../../../foreign/kanata/kbd.kbd}";
        serviceConfig = {
          keepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/kanata.out.log";
          StandardErrorPath = "/tmp/kanata.err.log";
        };
      };
    };
  };
}
