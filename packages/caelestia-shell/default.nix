# Caelestia shell with local fixes. Import this everywhere the shell is referenced
# so the systemd service and the `caelestia-shell ipc` in PATH share one store path
# (quickshell IPC finds the running instance by its config path).
{ inputs, system }:
inputs.qs-caelestia-shell.packages.${system}.default.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    # Lock screen notification groups spin in a polish() loop, pinning a core
    # and growing memory the longer the session stays locked.
    ./lock-notifgroup-polish-loop.patch
  ];
})
