{ ... }:
{
  wayland.windowManager.hyprland.settings = {

    "$mainMod" = "SUPER";
    bind = [
      "SUPER_SHIFT, V, exec, ghostty --title=clipse -e clipse"
      "$mainMod, return, exec, $terminal"
      "$mainMod, Q, killactive,"
      "$mainMod, B, exec, $browser"
      "$mainMod, M, exit,"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, F, togglefloating,"
      "$mainMod, R, exec, $run-menu"
      "ALT, TAB, exec, $window-menu"
      "$mainMod ALT, E, exec, $file-menu"
      ''$mainMod, C, exec, grim -g "$(slurp)" - | swappy -f -''

      #"$mainMod, P, pseudo, # dwindle"
      "$mainMod, J, togglesplit, # dwindle"

      "$mainMod, V, fullscreen"

      # Move focus with mainMod + arrow keys
      "$mainMod, h, movefocus, l"
      "$mainMod, l, movefocus, r"
      "$mainMod, k, movefocus, u"
      "$mainMod, j, movefocus, d"

      "$mainMod SHIFT, h, swapwindow, l"
      "$mainMod SHIFT, l, swapwindow, r"
      "$mainMod SHIFT, k, swapwindow, u"
      "$mainMod SHIFT, j, swapwindow, d"

      "$mainMod CTRL, j, workspace, e+1"
      "$mainMod CTRL, k, workspace, e-1"

      # Group Bindings
      "$mainMod, g, togglegroup"
      "$mainMod ALT, l, changegroupactive, f"
      "$mainMod ALT, h, changegroupactive, b"

      "$mainMod ALT SHIFT, h, moveintogroup, l"
      "$mainMod ALT SHIFT, l, moveintogroup, r"
      "$mainMod ALT SHIFT, k, moveintogroup, u"
      "$mainMod ALT SHIFT, j, moveintogroup, d"

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, split:workspace, 1"
      "$mainMod, 2, split:workspace, 2"
      "$mainMod, 3, split:workspace, 3"
      "$mainMod, 4, split:workspace, 4"
      "$mainMod, 5, split:workspace, 5"
      "$mainMod, 6, split:workspace, 6"
      "$mainMod, 7, split:workspace, 7"
      "$mainMod, 8, split:workspace, 8"
      "$mainMod, 9, split:workspace, 9"
      "$mainMod, 0, split:workspace, 10"
      "$mainMod, n, workspace, name:notes"
      "$mainMod, p, workspace, name:project"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, split:movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, split:movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, split:movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, split:movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, split:movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, split:movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, split:movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, split:movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, split:movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, split:movetoworkspacesilent, 10"
      "$mainMod SHIFT, n, movetoworkspacesilent, name:notes"
      "$mainMod SHIFT, p, movetoworkspacesilent, name:project"

      # Example special workspace (scratchpad)
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];

    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    bindel = [
      # Laptop multimedia keys for volume and LCD brightness
      ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
      ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
    ];

    bindl = [
      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };
}
