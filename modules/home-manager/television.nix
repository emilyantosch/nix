{ ... }:
{
  programs.television = {
    enable = true;
    enableFishIntegration = true;
    channels = {
      files = {
        metadata = {
          name = "files";
          description = "A channel to select files and directories";
          requirements = [
            "fd"
            "bat"
          ];
        };
        source = {
          command = [
            "fd -t f"
            "fd -t f -H"
          ];
        };
        preview = {
          command = "bat -n --color=always '{}'";
          env = {
            BAT_THEME = "ansi";
          };
        };
        keybindings = {
          shortcut = "f1";
          enter = "actions:edit";
          ctrl-up = "actions:goto_parent_dir";
        };
        actions = {
          edit = {
            description = "Opens the selected entries with the default editor (falls back to vim)";
            command = "${"EDITOR:va"} '{}'";
            shell = "bash";
            mode = "execute";
          };
          goto_parent_dir = {
            description = "Re-opens tv in the parent directory";
            command = "tv files ..";
            mode = "execute";
          };
        };
      };
      sesh = {
        metadata = {
          name = "sesh";
          description = "Session manager integrating tmux sessions, zoxide directories, and config paths";
          requirements = [
            "sesh"
            "fd"
          ];
        };
        source = {
          command = [
            "sesh list --icons"
            "sesh list -t --icons"
            "sesh list -c --icons"
            "sesh list -z --icons"
            "fd -H -d 2 -t d -E .Trash . ~"
          ];
          ansi = true;
          output = "{strip_ansi|split: :1..|join: }";
        };
        preview = {
          command = "sesh preview '{strip_ansi|split: :1..|join: }'";
        };
        keybindings = {
          enter = "actions:connect";
          ctrl-d = [
            "actions:kill_session"
            "reload_source"
          ];
        };
        actions = {
          connect = {
            description = "Connect to selected session";
            command = "sesh connect '{strip_ansi|split: :1..|join: }'";
            mode = "execute";
          };
          kill_session = {
            description = "Kill selected tmux session (press Ctrl+r to reload)";
            command = "tmux kill-session -t '{strip_ansi|split: :1..|join: }'";
            mode = "fork";
          };
        };
      };
    };
  };
}
