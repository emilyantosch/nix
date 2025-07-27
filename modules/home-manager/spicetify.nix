{ inputs, pkgs, ... }:
let
  # system = "x86_64-linux";
  spicePkgs = inputs.spicetify-nix.legacyPackages."x86_64-linux";
in
{
  # Configured over normal module not home-manager
  programs.spicetify = {
    enable = true;
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
