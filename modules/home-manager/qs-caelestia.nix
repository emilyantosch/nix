{ pkgs, ... }:
{
  home.file.".config/caelestia/shell.json".source = ../../foreign/caelestia/shell.json;
  home.file.".config/caelestia/cli.json".source = ../../foreign/caelestia/cli.json;
}
