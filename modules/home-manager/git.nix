{ config, ... }:
{
  home.file = {
    ".gitconfig" = {
      source = config.lib.file.mkOutOfStoreSymlink "~/.config/nix/foreign/git/.gitconfig";
    };
  };
}
