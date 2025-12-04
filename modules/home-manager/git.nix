{ config, ... }:
{
  home.file = {
    ".gitconfig" = {
      source = config.lib.file.mkOutOfStoreSymLink "~/.config/nix/foreign/git/.gitconfig";
    };
  };
}
