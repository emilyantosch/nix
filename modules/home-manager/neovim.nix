{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs;
      [
        doq
        sqlite
        cargo
        clang
        cmake
        ruff
        gcc
        gnumake
        ninja
        pkg-config
        yarn
        docker-ls
        nil
      ];

    extraLuaPackages = ls: with ls; [ luarocks ];
  };
}
