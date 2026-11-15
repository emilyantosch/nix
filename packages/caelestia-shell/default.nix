# Caelestia shell with local fixes. Import this everywhere the shell is referenced
# so the systemd service and the `caelestia-shell ipc` in PATH share one store path
# (quickshell IPC finds the running instance by its config path).
{ inputs, system }:
inputs.qs-caelestia-shell.packages.${system}.default.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    # Lock screen notification groups spin in a polish() loop, pinning a core
    # and growing memory the longer the session stays locked.
    ./lock-notifgroup-polish-loop.patch
    # Close the hover-opened launcher once the mouse leaves it, like the
    # dashboard/utilities do. Shortcut-opened launchers stay open.
    ./launcher-hide-on-leave.patch
    # niri: find the active screen from niri's event stream instead of Hyprland
    # (shortcuts/IPC did nothing), and give the launcher keyboard focus without a click.
    ./niri-compat.patch
    # `caelestia-shell ipc call launcher wallpapers` opens the launcher in the
    # wallpaper picker (there was no way to get there without typing ">wallpaper ").
    ./launcher-wallpapers.patch
    # Hovering a wallpaper previews the curated theme `caelestia-theme apply`
    # would pick for it (upstream only previews the dynamic scheme).
    ./launcher-curated-preview.patch
    # Launch apps in their own systemd scopes. They used to stay in the shell's
    # cgroup, so Zen/Steam/Spotify ate into its 4G MemoryMax, got the shell
    # OOM-killed (leaving niri locked with no lock surface: red screen) and
    # were killed along with it.
    ./launcher-own-scope.patch
    # Bar indicator for voxtype dictation (modules/home-manager/voxtype.nix): a
    # pulsing mic while recording, a spinner while transcribing, hidden when idle;
    # a hover-only bar slides out while dictating.
    # Click finishes, right click discards; hover shows the state. Plus a
    # bottom-centre pill (where the launcher opens) with a live mic waveform.
    ./voxtype-indicator.patch
    # Audio recording (modules/home-manager/voice-record.nix) in the bar and the
    # bottom pill, cycling through the recording GIFs; the writing girl replaces
    # the dictation mic. Upstream's Recorder is the screen recorder, hence AudioRecorder.
    ./recorder-gifs.patch
    # "Keep awake" did nothing on niri: it only honours a wayland idle inhibitor
    # whose surface is on screen, and the shell's is a 0x0 window. Make the
    # toggle switch off the shell's own idle timeouts (lock, monitors, suspend).
    ./keep-awake-niri.patch
  ];

  # Background-free, trimmed copies of the GIFs, read from assets/gifs/
  postPatch = (old.postPatch or "") + ''
    cp -r --no-preserve=mode ${../../assets/gifs} assets/gifs
  '';
})
