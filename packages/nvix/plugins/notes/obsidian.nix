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
      "<leader>n"
      "󰎚"
      "notes"
    ])
  ];
  keymaps = [
    (mkKeymap "n" "<leader>nn" "<cmd>ObsidianNewNote<cr>" "Create new note")
    (mkKeymap "n" "<leader>nk" "<cmd>ObsidianQuickSwitch<cr>" "Quick Switch")
    (mkKeymap "n" "<leader>nd" "<cmd>ObsidianDailies<cr>" "Show Daily Notes")
    (mkKeymap "n" "<leader>nt" "<cmd>ObsidianToday<cr>" "Go to Today")
    (mkKeymap "n" "<leader>ns" "<cmd>ObsidianSearch<cr>" "Search")
    (mkKeymap "n" "<leader>nl" "<cmd>ObsidianLink<cr>" "Create link")
    (mkKeymap "n" "<leader>nb" "<cmd>ObsidianBacklinks<cr>" "List Backlinks")
    (mkKeymap "n" "<leader>ng" "<cmd>ObsidianTags<cr>" "List Tags")
    (mkKeymap "v" "<leader>ne" "<cmd>ObsidianExtractNote<cr>" "Extract into Notes")
  ];
}
