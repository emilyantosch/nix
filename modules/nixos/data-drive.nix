{ pkgs, ... }:
{
  # Second Samsung 990 PRO 2TB (nvme1n1), formatted as a single btrfs partition labelled "data".
  environment.systemPackages = [ pkgs.btrfs-progs ];

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "btrfs";
    # nofail + short timeout: a missing/unformatted drive must not block boot.
    options = [ "compress=zstd" "noatime" "nofail" "x-systemd.device-timeout=5s" ];
  };

  # The btrfs root is created root-owned; hand it to emmi.
  systemd.tmpfiles.rules = [ "d /mnt/data 0755 emmi users -" ];

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/mnt/data" ];
  };
}
