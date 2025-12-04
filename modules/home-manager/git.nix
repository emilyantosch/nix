{ config, system, user, ... }:
{
  home.file = {
    ".gitconfig" = {
      source = config.lib.file.mkOutOfStoreSymlink "/Users/emilylucia.antosch/.config/nix/foreign/git/.gitconfig";
    };
  };
}
