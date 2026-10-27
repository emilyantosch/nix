# Caelestia CLI plus the curated wallpaper-matched themes. Import this wherever
# the CLI is installed; the shell finds `caelestia` (and the schemes) via PATH.
#
#   caelestia scheme set -n curated -f <theme> -m dark|light
#   caelestia-theme apply|rank|set|next|prev|auto|mode|list
{ inputs, system }:
inputs.qs-caelestia-cli.packages.${system}.default.overrideAttrs (old: {
  # Render the curated palettes into the bundled scheme data so they show up
  # in `caelestia scheme list` and the launcher's scheme picker.
  preBuild = (old.preBuild or "") + "\n" + ''
    python3 ${./themes}/gen_schemes.py src/caelestia/data/schemes/curated \
      src/caelestia/data/schemes/catppuccin/mocha/dark.txt
  '';

  # Gets wrapped with the CLI's python env (Pillow, caelestia) by the
  # buildPythonApplication fixup like the `caelestia` script itself.
  postInstall = (old.postInstall or "") + "\n" + ''
    install -Dm755 ${./caelestia-theme.py} $out/bin/caelestia-theme
  '';
})
