{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config.nvix.mkKey) wKeyObj mkKeymap;
  inherit (config.nvix) icons;
  inherit (lib.nixvim) mkRaw;
in
{
  plugins = {
    orgmode = {
      enable = true;
      settings = { };
    };
  };

  wKeyList = [
    (wKeyObj [
      "<leader>r"
      ""
      "orgmode"
    ])
  ];
  keymaps = [
    (mkKeymap "n" "<leader>rn" "<cmd>ObsidianNewNote<cr>" "Create new note")
    (mkKeymap "n" "<leader>rk" "<cmd>ObsidianQuickSwitch<cr>" "Quick Switch")
    (mkKeymap "n" "<leader>rd" "<cmd>ObsidianDailies<cr>" "Show Daily Notes")
    (mkKeymap "n" "<leader>rt" "<cmd>ObsidianToday<cr>" "Go to Today")
    (mkKeymap "n" "<leader>rs" "<cmd>ObsidianSearch<cr>" "Search")
    (mkKeymap "n" "<leader>rl" "<cmd>ObsidianLink<cr>" "Create link")
    (mkKeymap "n" "<leader>rb" "<cmd>ObsidianBacklinks<cr>" "List Backlinks")
    (mkKeymap "n" "<leader>rg" "<cmd>ObsidianTags<cr>" "List Tags")
    (mkKeymap "v" "<leader>re" "<cmd>ObsidianExtractNote<cr>" "Extract into Notes")
  ];
}
