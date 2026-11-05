{ pkgs, inputs, config, ... }:
let
  # Same store path as the running shell, so `ipc call` finds it.
  caelestia-shell = import ../../packages/caelestia-shell {
    inherit inputs;
    system = pkgs.stdenv.hostPlatform.system;
  };

  recordingsDir = "${config.home.homeDirectory}/Music/Recordings";

  # Audio recorder for Super+D (dictation is Super+Shift+D, see voxtype.nix).
  # pw-record runs as the transient voice-recording user unit, so it outlives
  # whatever spawned it and the shell can read its state from systemd. Every
  # start and stop pings the shell, which shows a GIF in the bar while it runs.
  voice-record = pkgs.writeShellApplication {
    name = "voice-record";
    runtimeInputs = [ pkgs.coreutils pkgs.systemd pkgs.pipewire pkgs.libnotify caelestia-shell ];
    text = ''
      unit=voice-recording
      cancelMarker="''${XDG_RUNTIME_DIR:-/run/user/$UID}/voice-recording.cancel"
      self=$(readlink -f "$0")

      ping_shell() {
        caelestia-shell ipc call audiorecorder refresh >/dev/null 2>&1 || true
      }

      active() {
        systemctl --user is-active --quiet "$unit"
      }

      start() {
        active && return 0
        mkdir -p "${recordingsDir}"
        file="${recordingsDir}/Recording $(date '+%Y-%m-%d %H-%M-%S').flac"
        rm -f "$cancelMarker"
        systemctl --user reset-failed "$unit" >/dev/null 2>&1 || true
        # SIGINT lets pw-record finish the FLAC cleanly (it then exits 1, hence
        # SuccessExitStatus; an empty file still counts as failed). The RØDE AI-1 like
        # voxtype; WirePlumber falls back to the default source without it.
        systemd-run --user --quiet --collect --unit="$unit" \
          --description="Voice recording" \
          --setenv=RECORDING_FILE="$file" \
          -p KillSignal=SIGINT \
          -p SuccessExitStatus=1 \
          -p ExecStopPost="$self finished" \
          pw-record \
            --target alsa_input.usb-RODE_Microphones_RODE_AI-1_F8020BF8-00.mono-fallback \
            --channels 1 \
            "$file"
        ping_shell
      }

      stop() {
        # Blocks until ExecStopPost (finished) has run
        active && systemctl --user stop "$unit"
        ping_shell
      }

      case "''${1:-toggle}" in
        toggle) if active; then stop; else start; fi ;;
        start) start ;;
        stop) stop ;;
        cancel)
          if active; then
            touch "$cancelMarker"
            stop
          fi
          ;;
        # ExecStopPost of the unit: RECORDING_FILE comes from its environment
        finished)
          file=''${RECORDING_FILE:-}
          if [ -e "$cancelMarker" ]; then
            rm -f "$cancelMarker" "$file"
          elif [ -s "$file" ]; then
            notify-send -a "Recorder" -i audio-x-generic \
              "Recording saved" "$(basename "$file")" || true
          else
            rm -f "$file"
            notify-send -a "Recorder" -u critical \
              "Recording failed" "pw-record exited: ''${SERVICE_RESULT:-unknown}" || true
          fi
          ping_shell
          ;;
        *)
          echo "usage: voice-record [toggle|start|stop|cancel]" >&2
          exit 1
          ;;
      esac
    '';
  };
in
{
  home.packages = [ voice-record ];
}
