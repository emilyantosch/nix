{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  # For Kanata enable uinput
  boot.kernelModules = [ "uinput" ];
  hardware.uinput.enable = true;

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        # devices = ["/dev/input/by-id/usb-Wooting_Wooting_60HE__ARM__A02B2341W052H02336-if01-event-kbd"];
        extraDefCfg = "process-unmapped-keys yes";
        configFile = ./../../foreign/kanata/kbd.kbd;
        };
    };
  };
}
