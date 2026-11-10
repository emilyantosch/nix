{ ... }:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    # `settings` -> yazi.toml, `theme` -> theme.toml (flavors belong in theme.toml)
    theme = {
      flavor = {
        dark = "gruvbox-dark";
      };
    };
  };
}
