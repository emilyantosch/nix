{ config, pkgs, ... }:
# Share the Sony A7 IV (USB streaming / UVC) between several apps at once.
#
# A UVC camera can only stream to one process, so Vesktop and the browser
# (Foundry) fight over /dev/video0. Instead, ffmpeg owns the real camera and
# copies the feed into two v4l2loopback devices:
#   /dev/video10  "A7IV Discord"  -> pick this one in Vesktop
#   /dev/video11  "A7IV Browser"  -> pick this one in Zen / Foundry
# The service starts when the camera is plugged in and stops when it goes away.
let
  # The A7 IV in USB streaming mode only offers MJPEG 1280x720 @ 25 fps.
  # v4l2loopback output via ffmpeg must be raw video, so decode once to yuv420p
  # (supported by both Chromium/Electron and Firefox).
  fanOut = pkgs.writeShellScript "a7iv-loopback" ''
    exec ${pkgs.ffmpeg-headless}/bin/ffmpeg -hide_banner -loglevel warning \
      -f v4l2 -input_format mjpeg -video_size 1280x720 -framerate 25 -i /dev/a7iv \
      -map 0:v -pix_fmt yuv420p -f v4l2 /dev/video10 \
      -map 0:v -pix_fmt yuv420p -f v4l2 /dev/video11
  '';
in
{
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  # exclusive_caps=1 is required for Chromium/Electron to list the devices as cameras.
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=2 video_nr=10,11 card_label="A7IV Discord","A7IV Browser" exclusive_caps=1,1
  '';

  # Stable /dev/a7iv symlink for the camera's capture node (index 0; index 1 is metadata),
  # and start the fan-out service whenever it appears.
  services.udev.extraRules = ''
    SUBSYSTEM=="video4linux", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0de7", ATTR{index}=="0", SYMLINK+="a7iv", TAG+="systemd", ENV{SYSTEMD_WANTS}+="a7iv-loopback.service"
  '';

  systemd.services.a7iv-loopback = {
    description = "Fan out Sony A7 IV webcam to v4l2loopback devices";
    bindsTo = [ "dev-a7iv.device" ];
    after = [ "dev-a7iv.device" ];
    serviceConfig = {
      ExecStart = fanOut;
      DynamicUser = true;
      SupplementaryGroups = [ "video" ];
      # Retries if another app still has the real camera open.
      Restart = "always";
      RestartSec = 3;
    };
  };
}
