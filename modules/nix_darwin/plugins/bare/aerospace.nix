{pkgs, ...}:
{
  homebrew = {
    taps = [
      "nikitabobko/tap"
    ];
    casks = [
      "aerospace"
    ];
  };

  services.aerospace = {
    enable = true;

    settings = {
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # Default Layout and Orientation
      default-root-container-layout = "accordion";
      default-root-container-orientation = "auto";

      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];

      automatically-unhide-macos-hidden-apps = true;

      gaps = {
        inner.horizontal = 10;
        inner.vertical = 10;
        outer.left = 10;
        outer.bottom = 10;
        outer.right = 10;
        outer.top = 10;
      };


# All possible keys:
# - Letters.        a, b, c, ..., z
# - Numbers.        0, 1, 2, ..., 9
# - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
# - F-keys.         f1, f2, ..., f20
# - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
#                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
# - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
#                   keypadMinus, keypadMultiply, keypadPlus
# - Arrows.         left, down, up, right

# All possible modifiers: cmd, alt, ctrl, shift

# All possible commands: https://nikitabobko.github.io/AeroSpace/commands

# See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
# You can uncomment the following lines to open up terminal with alt + enter shortcut (like in i3)
# alt-enter = '''exec-and-forget osascript -e '
# tell application "Terminal"
#     do script
#     activate
# end tell'
# '''
mode.main.binding = {

  cmd-alt-ctrl-shift-enter = ["exec-and-forget open -a /Applications/Ghostty.app"];


  alt-ctrl-shift-f = "fullscreen";
  alt-ctrl-f = "layout floating tiling";

  alt-shift-left = "join-with left";
  alt-shift-down = "join-with down";
  alt-shift-up = "join-with up";
  alt-shift-right = "join-with right";

# See: https://nikitabobko.github.io/AeroSpace/commands#layout
  alt-slash = "layout tiles horizontal vertical";
  alt-comma = "layout accordion horizontal vertical";

# See: https://nikitabobko.github.io/AeroSpace/commands#focus
  cmd-alt-ctrl-shift-h = "focus left";
  cmd-alt-ctrl-shift-l = "focus right";
  cmd-alt-ctrl-shift-j = "focus down";
  cmd-alt-ctrl-shift-k = "focus up";

# See: https://nikitabobko.github.io/AeroSpace/commands#move
  alt-shift-h = "move left";
  alt-shift-j = "move down";
  alt-shift-k = "move up";
  alt-shift-l = "move right";

# See: https://nikitabobko.github.io/AeroSpace/commands#resize
  alt-shift-minus = "resize smart -50";
  alt-shift-equal = "resize smart +50";

# See: https://nikitabobko.github.io/AeroSpace/commands#workspace
  cmd-alt-ctrl-shift-1 = "workspace 1";
  cmd-alt-ctrl-shift-2 = "workspace 2";
  cmd-alt-ctrl-shift-3 = "workspace 3";
  cmd-alt-ctrl-shift-4 = "workspace 4";
  cmd-alt-ctrl-shift-5 = "workspace 5";
  cmd-alt-ctrl-shift-6 = "workspace 6";
  cmd-alt-ctrl-shift-7 = "workspace 7";
  cmd-alt-ctrl-shift-8 = "workspace 8";

  cmd-alt-ctrl-shift-m = "mode move";

# See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
#
  alt-shift-1 = "move-node-to-workspace 1 --focus-follows-window";
  alt-shift-2 = "move-node-to-workspace 2 --focus-follows-window";
  alt-shift-3 = "move-node-to-workspace 3 --focus-follows-window";
  alt-shift-4 = "move-node-to-workspace 4 --focus-follows-window";
  alt-shift-5 = "move-node-to-workspace 5 --focus-follows-window";

  alt-tab = "workspace-back-and-forth";
  alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

# See: https://nikitabobko.github.io/AeroSpace/commands#mode
  alt-shift-s = "mode service";
  alt-shift-enter = "mode apps";

  alt-e = "exec-and-forget open -a /System/Library/CoreServices/Finder.app";
  alt-o = "exec-and-forget open -a /Applications/Obsidian.app";
  alt-t = "exec-and-forget open -a /Applications/Ghostty.app";
  alt-b = "exec-and-forget open -a /Applications/Zen Browser.app";
  alt-p = "exec-and-forget open -a /Applications/sioyek.app";
};

# 'service' binding mode declaration.
# See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
mode.move.binding = {
  cmd-alt-ctrl-shift-1 = [
    "move-node-to-workspace 1 --focus-follows-window"
    "mode main"
  ];
  cmd-alt-ctrl-shift-2 = [
    "move-node-to-workspace 2 --focus-follows-window"
    "mode main"
  ];
  cmd-alt-ctrl-shift-3 = [
    "move-node-to-workspace 3 --focus-follows-window"
    "mode main"
  ];
  cmd-alt-ctrl-shift-4 = [
    "move-node-to-workspace 4 --focus-follows-window"
    "mode main"
  ];
  cmd-alt-ctrl-shift-5 = [
    "move-node-to-workspace 5 --focus-follows-window"
    "mode main"
  ];
  cmd-alt-ctrl-shift-6 = [
    "move-node-to-workspace 6 --focus-follows-window"
    "mode main"
  ];
  cmd-alt-ctrl-shift-7 = [
    "move-node-to-workspace 7 --focus-follows-window"
    "mode main"
  ];
  cmd-alt-ctrl-shift-8 = [
    "move-node-to-workspace 8 --focus-follows-window"
    "mode main"
  ];
};

    mode.service.binding = {
      esc = ["reload-config" "mode main"];
      r = ["flatten-workspace-tree" "mode main"];
      f = [
        "layout floating tiling"
        "mode main"
      ];
      backspace = ["close-all-windows-but-current" "mode main"];
      };
    };
  };
}
