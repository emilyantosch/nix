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
    obsidian = {
      enable = true;
      settings = {
        completion = {
          min_chars = 2;
          blink_cmp = true;
        };
        workspaces = [
          {
            name = "notes";
            path = "~/projects/notes/emmiNotes/";
          }
        ];
      };
    };
  };

  wKeyList = [
    (wKeyObj [
      "<leader>o"
      "󰎚"
      "notes"
    ])
  ];
  keymaps = [
    (mkKeymap "n" "<leader>on" "<cmd>ObsidianNewNote<cr>" "Create new note")
    (mkKeymap "n" "<leader>ok" "<cmd>ObsidianQuickSwitch<cr>" "Quick Switch")
    (mkKeymap "n" "<leader>od" "<cmd>ObsidianDailies<cr>" "Show Daily Notes")
    (mkKeymap "n" "<leader>ot" "<cmd>ObsidianToday<cr>" "Go to Today")
    (mkKeymap "n" "<leader>os" "<cmd>ObsidianSearch<cr>" "Search")
    (mkKeymap "n" "<leader>ol" "<cmd>ObsidianLink<cr>" "Create link")
    (mkKeymap "n" "<leader>ob" "<cmd>ObsidianBacklinks<cr>" "List Backlinks")
    (mkKeymap "n" "<leader>og" "<cmd>ObsidianTags<cr>" "List Tags")
    (mkKeymap "v" "<leader>oe" "<cmd>ObsidianExtractNote<cr>" "Extract into Notes")
  ];
}
