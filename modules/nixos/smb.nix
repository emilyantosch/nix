{pkgs,...}:
{
  environment.systemPackages = with pkgs; [
    cifs-utils
    samba
  ];
  fileSystems."/mnt/emmi-share" = {
    device = "//192.168.68.59/emmi-share";
    fsType = "cifs";
    options = [ "username=emmi" "password=gend" "x-systemd.automount" "noauto" ];
  };
  
}
