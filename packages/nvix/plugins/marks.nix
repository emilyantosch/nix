{ config, lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nvix) icons;
  inherit (config.nvix.mkKey) mkKeymap wKeyObj;
in
{
  plugins = {
    marks = {
      enable = false;
      settings = {
        cyclic = true;
        mappings = {
          delete = "<leader>md";
          delete_buf = "<leader>mc";
          delete_line = "<leader>mD";
          next = "<leader>mn";
          prev = "<leader>mp";
          set = "<leader>mM";
          toggle = "<leader>mm";
          set_bookmark0 = "<leader>mb0";
          next_bookmark = "<leader>mbn";
          prev_bookmark = "<leader>mbN";
        };
        refreshInterval = 150;
      };
    };
  };
}
