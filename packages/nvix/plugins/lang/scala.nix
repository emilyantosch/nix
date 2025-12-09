{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (config.nvix) icons;
  inherit (lib.nixvim) mkRaw;
in
{
  plugins = {
    lsp.servers.metals.enable = true;
  };
}
