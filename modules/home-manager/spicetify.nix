{ inputs, pkgs, config, ... }:
let
  # system = "x86_64-linux";
  spicePkgs = inputs.spicetify-nix.legacyPackages."x86_64-linux";
  # Rendered by caelestia on every scheme change (qs-caelestia.nix).
  caelestiaCss = "${config.xdg.stateHome}/caelestia/theme/spicetify.css";
in
{
  # Configured over normal module not home-manager
  programs.spicetify = {
    enable = true;
    # The spiced package is read-only, so caelestia can't rewrite its colours.
    # Link a file it can rewrite into xpui instead (after spicetify applied,
    # hence postFixup); the caelestiaColours extension keeps it loaded.
    spotifyPackage = pkgs.spotify.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        ln -s ${caelestiaCss} $out/share/spotify/Apps/xpui/caelestia.css
      '';
    });
    theme = {
      name = "Gruvbox";

      src = pkgs.fetchFromGitHub {
        owner = "Skaytacium";
        repo = "Gruvify";
        rev = "69500f908ebf93907a0eb58ab86b5d53ef8e9326";
        hash = "sha256-1kSePoU2UaRt+I1ognm//pHxEl+WTYDWCjXDZkVHi4g";
      };
      injectCss = true;
      injectThemeJs = true;
      replaceColors = true;
      homeConfig = true;
      overwriteAssets = false;
      additionalCss = "";
    };
    # theme = spicePkgs.themes.text;
    # theme = spicePkgs.themes.TokyoNight;
    # theme = spicePkgs.themes.defaultDynamic;
    enabledExtensions = with spicePkgs.extensions; [
      hidePodcasts
      keyboardShortcut
      beautifulLyrics
      # simpleBeautifulLyrics
      queueTime
      history
      phraseToPlaylist
      fullAppDisplay
      {
        src = ../../foreign/spicetify;
        name = "caelestiaColours.js";
      }
    ];
    # Theme for catppuccin
    # colorScheme = "mocha";
    # Themes for Text
    # colorScheme = "RosePine";
    # colorScheme = "CatppuccinMocha";
    # colorScheme = "TokyoNight";
    # colorScheme = "Storm";
    # Theme for dynamic
    # colorScheme = "Base";
  };
}
