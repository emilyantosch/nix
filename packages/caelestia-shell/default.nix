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
  ];
})
