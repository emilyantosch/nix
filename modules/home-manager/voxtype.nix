{ pkgs, lib, ... }:
let
  voxtype = pkgs.voxtype-vulkan; # whisper.cpp on the GPU through Vulkan

  # Pinned instead of `voxtype setup model`, so a fresh install works without a
  # manual download. Full-precision turbo: fits easily in the 4070 Ti's VRAM.
  model = pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/5359861c739e955e79d9a303bcbc70fb988958b1/ggml-large-v3-turbo.bin";
    sha256 = "1fc70f774d38eb169993ac391eea357ef47c88757ef72ee5943879b7e8e2bc69";
  };

  settings = {
    state_file = "auto"; # caelestia's bar indicator follows this

    # Started/stopped by niri keybinds (Super+Shift+D / Super+Ctrl+D) instead;
    # Super+D is audio recording (voice-record.nix).
    hotkey.enabled = false;

    whisper = {
      inherit model;
      # Restrict auto-detection to these, so short clips don't come out in
      # some third language.
      language = [ "en" "de" ];
      translate = false;
    };

    audio = {
      device = "default";
      max_duration_secs = 120;
    };

    output = {
      mode = "type"; # wtype: types Unicode independent of the de layout
      fallback_to_clipboard = true;
      # Default true; works because emmi is in the input group.
      wait_for_modifier_release = true;
      notification = {
        on_recording_start = false;
        on_recording_stop = false;
        on_transcription = false; # the bar indicator shows progress
      };
    };

    # Drop recordings without speech instead of letting Whisper hallucinate
    # "Thank you." from silence. Energy backend: no extra model to download.
    vad = {
      enabled = true;
      backend = "energy";
    };

    # caelestia shows the state in the bar; no separate GTK overlay.
    osd.enabled = false;
  };

  configFile = (pkgs.formats.toml { }).generate "voxtype.toml" settings;
in
{
  home.packages = [ voxtype ];

  xdg.configFile."voxtype/config.toml".source = configFile;

  systemd.user.services.voxtype = {
    Unit = {
      Description = "Voxtype dictation daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" "pipewire.service" ];
      # The daemon only reads its config at startup.
      X-Restart-Triggers = [ "${configFile}" ];
    };
    Service = {
      ExecStart = "${lib.getExe voxtype} daemon";
      # Record from the RØDE AI-1, not PipeWire's default source (the ADI-2 DAC's
      # unused input, which gave pure silence that Whisper hears as "Thank you.").
      # voxtype only takes cpal device names, but its "default" ALSA device goes
      # through pipewire-alsa, which honours this. Falls back to the default
      # source if the RØDE is missing or held by an app (e.g. Audacity via ALSA).
      Environment = [
        "PIPEWIRE_NODE=alsa_input.usb-RODE_Microphones_RODE_AI-1_F8020BF8-00.mono-fallback"
      ];
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
