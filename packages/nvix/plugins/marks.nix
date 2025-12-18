{ config, lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nvix) icons;
  inherit (config.nvix.mkKey) mkKeymap wKeyObj;
in
{
  plugins = {
    marks = {
      enable = true;
      settings = {
        cyclic = true;
        mappings = {
          delete = "<Leader>md";
          delete_buf = "<Leader>mc";
          delete_line = "<Leader>mD";
          next = "<Leader>mn";
          prev = "<Leader>mp";
          set = "<Leader>mM";
          toggle = "<Leader>mm";
          set_bookmark0 = "<Leader>mb0";
          next_bookmark = "<Leader>mbn";
          prev_bookmark = "<Leader>mbN";
        };
        refreshInterval = 150;

      };
    };
  };
}
