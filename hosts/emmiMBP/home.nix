{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./../../modules/home-manager/tmux.nix
    ./../../modules/home-manager/starship.nix
    ./../../modules/home-manager/ghostty.nix
    ./../../modules/home-manager/yazi.nix
    ./../../modules/home-manager/nushell.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "emmi";
    homeDirectory = "/Users/emmi";

    stateVersion = "25.05";
  };
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
