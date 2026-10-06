{pkgs,...}:
{
  environment.systemPackages = with pkgs; [
    cifs-utils
    samba
  ];
  fileSystems."/mnt/emmi-share" = {
    device = "//192.168.68.59/emmi-share";
    fsType = "cifs";
    # No automount: anything stat-ing mounts (e.g. Caelestia's storage widget) would
    # block for ~10s per attempt whenever the NAS is unreachable. Mount manually.
    options = [ "username=emmi" "password=gend" "noauto" ];
  };
  
}
