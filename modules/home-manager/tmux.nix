{ pkgs, lib, ... }:
let
  fish = lib.getExe pkgs.fish;
in
{
  programs.tmux = {
    enable = true;
    #shortcut = " ";
    shell = "${pkgs.nushell}/bin/nu";
    terminal = "tmux-256color";
    historyLimit = 10000;
    baseIndex = 1;
    extraConfig = ''
      set -g mouse on

      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix

      bind h select-pane -L
      bind l select-pane -R
      bind j select-pane -D
      bind k select-pane -U
      bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt
      set -g detach-on-destroy off  # don't exit from tmux when closing a session

      unbind t
      bind-key t display-popup -E -w 80% -h 70% -d '#{pane_current_path}' -T 'Sesh' tv sesh

      bind C-c display-popup -E "claude"
      bind C-g display-popup -E "tmux attach -t notes"
      bind C-d display-popup

      set-option -g default-shell ${fish}
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      set -g default-terminal "tmux-256color"
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

    '';
    plugins = with pkgs; [
      # {
      #   plugin = tmuxPlugins.rose-pine;
      #   extraConfig =
      #   ''
      #     set -g @rose_pine_variant 'moon'
      #
      #     set -g @rose_pine_host 'on'
      #     set -g @rose_pine_date_time 'on'
      #     set -g @rose_pine_date_user 'on'
      #     set -g @rose_pine_date_directory 'on'
      #   '';
      # }
      {
        plugin = tmuxPlugins.gruvbox;
        extraConfig = ''
          set -g @tmux-gruvbox 'dark'
        '';
      }
      # {
      #   plugin = tmuxPlugins.resurrect;
      #   extraConfig = ''
      #     set -g @resurrect-strategy-vim 'session'
      #     set -g @resurrect-strategy-nvim 'session'
      #     set -g @resurrect-capture-pane-contents 'on'
      #   '';
      # }
      # {
      #   plugin = tmuxPlugins.continuum;
      #   extraConfig = ''
      #     set -g @continuum-restore 'on'
      #     set -g @continuum-boot 'on'
      #     set -g @continuum-save-interval '10'
      #   '';
      # }
    ];
  };
}
