{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{

  services.kanata = {
    enable = false;
    keyboards = {
      internalKeyboard = {
        # devices = ["/dev/input/by-id/usb-Wooting_Wooting_60HE__ARM__A02B2341W052H02336-if01-event-kbd"];
        extraDefCfg = "process-unmapped-keys yes";
        configFile = ./../../foreign/kanata/kbd.kbd;
        };
    };
  };
}
