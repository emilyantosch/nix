{
  config,
  system,
  user,
  ...
}:
{
  home.file = {
    ".gitignore" = {
      source = config.lib.file.mkOutOfStoreSymlink "/Users/emilylucia.antosch/.config/nix/foreign/git/.gitignore";
    };
  };
}
