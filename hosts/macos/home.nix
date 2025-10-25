{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
  ];

  programs = {
    ghostty = {
      enable = true;
      settings = {
        font-size = 18;
        window-decoration = false;
        confirm-close-surface = false;
        font-feature = [
          "liga"
          "dlig"
          "calt"
        ];
        background-opacity = 1;
        theme = "gruvbox-material";
        # custom-shader = "./assets/shaders/bettercrt.glsl";
      };
    };
  };
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "emmi";
    homeDirectory = "/home/emmi";
    stateVersion = "24.11"; # Please read the comment before changing.
    sessionVariables = {
      EDITOR = "nvim";
    };
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
