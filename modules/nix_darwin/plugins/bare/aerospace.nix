{ pkgs, ... }:
let
  # Ghostty only takes a fixed position, so center on the screen under the mouse
  # (AeroSpace moves the mouse to the focused monitor).
  # shortcut: 1164x711 is the measured size of 68x19 cells at font-size 28, re-measure if the font changes
  notes-window = pkgs.writeShellScript "notes-window" ''
    read -r x y < <(/usr/bin/osascript -l JavaScript -e '
      ObjC.import("AppKit");
      const m = $.NSEvent.mouseLocation;
      const s = $.NSScreen.screens.js.find(s => $.NSMouseInRect(m, s.frame, false)) || $.NSScreen.screens.js[0];
      const f = s.visibleFrame;
      Math.round((f.size.width - 1164) / 2) + " " + Math.round((f.size.height - 711) / 2)')
    exec open -na /Applications/Ghostty.app --args --title=notes \
      --window-save-state=never --quit-after-last-window-closed=true \
      --window-width=68 --window-height=19 \
      --window-position-x="$x" --window-position-y="$y" \
      --working-directory="$HOME/projects/notes/emmiNotes" \
      -e /opt/homebrew/bin/nvim index.md
  '';
in
{
  homebrew.casks = [
    "nikitabobko/tap/aerospace"
  ];

  services.aerospace = {
    enable = true;

    settings = {
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # Default Layout and Orientation
      default-root-container-layout = "accordion";
      default-root-container-orientation = "auto";
      accordion-padding = 200;

      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "main";
        "6" = "secondary";
        "7" = "secondary";
        "8" = "secondary";
        "9" = "secondary";
        "10" = "secondary";
      };

      automatically-unhide-macos-hidden-apps = true;

      on-window-detected = [
        {
          "if" = {
            app-id = "com.mitchellh.ghostty";
            window-title-regex-substring = "^notes$";
          };
          run = [ "layout floating" ];
        }
      ];

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

        cmd-alt-ctrl-shift-enter = [ "exec-and-forget open -a /Applications/Ghostty.app" ];
        # Separate Ghostty instance so the title (and on-window-detected rule below) stays fixed
        cmd-alt-ctrl-shift-n = [ "exec-and-forget ${notes-window}" ];

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
        cmd-alt-ctrl-shift-h = "focus --boundaries all-monitors-outer-frame left";
        cmd-alt-ctrl-shift-l = "focus --boundaries all-monitors-outer-frame right";
        cmd-alt-ctrl-shift-j = "focus --boundaries all-monitors-outer-frame down";
        cmd-alt-ctrl-shift-k = "focus --boundaries all-monitors-outer-frame up";

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
        cmd-alt-ctrl-shift-h = [
          "move --boundaries all-monitors-outer-frame left"
        ];
        cmd-alt-ctrl-shift-l = [
          "move --boundaries all-monitors-outer-frame right"
        ];
        cmd-alt-ctrl-shift-j = [
          "move --boundaries all-monitors-outer-frame down"
        ];
        cmd-alt-ctrl-shift-k = [
          "move --boundaries all-monitors-outer-frame up"
        ];
        cmd-alt-ctrl-shift-esc = [
          "mode main"
        ];
      };

      mode.service.binding = {
        esc = [
          "reload-config"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ];
        f = [
          "layout floating tiling"
          "mode main"
        ];
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];
      };
    };
  };
}
