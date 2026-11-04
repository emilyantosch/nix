{ pkgs, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = ''
        [](color_user)$os$username[](bg:color_directory fg:color_user)$directory[](fg:color_directory bg:color_git)$git_branch$git_status[](fg:color_git bg:color_lang)$c$cpp$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:color_lang bg:color_env)$nix_shell$aws$docker_context$conda$pixi[](fg:color_env bg:color_time)$time[ ](fg:color_time)$line_break$character
      '';
      palette = "gruvbox_dark";
      # Named by what they colour, so caelestia (qs-caelestia.nix) can swap in
      # its scheme's roles; these are the gruvbox values.
      palettes = {
        gruvbox_dark = {
          color_user = "#d65d0e";
          color_user_fg = "#fbf1c7";
          color_directory = "#d79921";
          color_directory_fg = "#fbf1c7";
          color_git = "#689d6a";
          color_git_fg = "#fbf1c7";
          color_lang = "#458588";
          color_lang_fg = "#fbf1c7";
          color_env = "#665c54";
          color_env_fg = "#fbf1c7";
          color_env_accent = "#83a598";
          color_time = "#3c3836";
          color_time_fg = "#fbf1c7";
          color_ok = "#98971a";
          color_error = "#cc241d";
          color_vim_replace = "#b16286";
          color_vim_visual = "#d79921";
        };
      };
      nodejs = {
        symbol = "";
        style = "bg:color_lang";
        format = "[[ $symbol( $version) ](fg:color_lang_fg bg:color_lang)]($style)";
      };
      aws = {
        format = "[on $symbol$profile]($style)";
        style = "bg:color_env";
        symbol = "";
        profile_aliases = {
          Enterprise_Naming_scheme-voidstars = "void**";
        };
      };
      c = {
        symbol = " ";
        style = "bg:color_lang";
        format = "[[ $symbol( $version) ](fg:color_lang_fg bg:color_lang)]($style)";
      };
      cpp = {
        symbol = " ";
        style = "bg:color_lang";
        format = "[[ $symbol( $version) ](fg:color_lang_fg bg:color_lang)]($style)";
      };
      rust = {
        symbol = "";
        style = "bg:color_lang";
        format = "[[ $symbol( $version) ](fg:color_lang_fg bg:color_lang)]($style)";
      };
      golang = {
        symbol = "";
        style = "bg:color_lang";
        format = "[[ $symbol( $version) ](fg:color_lang_fg bg:color_lang)]($style)";
      };
      php = {
        symbol = "";
        style = "bg:color_lang";
        format = "[[ $symbol( $version) ](fg:color_lang_fg bg:color_lang)]($style)";
      };
      python = {
        symbol = "";
        style = "bg:color_lang";
        format = "[[ $symbol( $version) ](fg:color_lang_fg bg:color_lang)]($style)";
      };
      shlvl = {
        disabled = false;
        symbol = "ﰬ";
        style = "bright-red bold";
      };
      directory = {
        style = "fg:color_directory_fg bg:color_directory";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        read_only = "read-only!";
      };
      shell = {
        disabled = false;
        format = "$indicator";
        fish_indicator = "";
        bash_indicator = "[BASH](bright-white) ";
        zsh_indicator = "[ZSH](bright-white) ";
      };
      username = {
        show_always = true;
        style_user = "bg:color_user fg:color_user_fg";
        style_root = "bg:color_user fg:color_user_fg";
        format = "[ $user ]($style)";

      };
      hostname = {
        style = "bright-green bold";
        ssh_only = true;
      };
      nix_shell = {
        symbol = "";
        format = "[[ $symbol ($name) ](fg:color_env_accent bg:color_env)]($style)";
        style = "bg:color_env";
      };
      git_branch = {
        symbol = "";
        style = "bg:color_git";
        format = "[[ $symbol $branch ](fg:color_git_fg bg:color_git)]($style)";
      };
      git_status = {
        style = "bg:color_git";
        format = "[[($all_status$ahead_behind )](fg:color_git_fg bg:color_git)]($style)";
      };
      docker_context = {
        symbol = "";
        style = "bg:color_env";
        format = "[[ $symbol( $context) ](fg:color_env_accent bg:color_env)]($style)";
      };
      conda = {
        style = "bg:color_env";
        format = "[[ $symbol( $environment) ](fg:color_env_accent bg:color_env)]($style)";
      };
      pixi = {
        style = "bg:color_env";
        format = "[[ $symbol( $version)( $environment) ](fg:color_env_fg bg:color_env)]($style)";
      };
      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:color_time";
        format = "[[  $time ](fg:color_time_fg bg:color_time)]($style)";
      };
      line_break = {
        disabled = false;
      };
      character = {
        disabled = false;
        success_symbol = "[](bold fg:color_ok)";
        error_symbol = "[](bold fg:color_error)";
        vimcmd_symbol = "[](bold fg:color_ok)";
        vimcmd_replace_one_symbol = "[](bold fg:color_vim_replace)";
        vimcmd_replace_symbol = "[](bold fg:color_vim_replace)";
        vimcmd_visual_symbol = "[](bold fg:color_vim_visual)";
      };
      os = {
        disabled = false;
        style = "bg:color_user fg:color_user_fg";
        symbols = {
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          NixOS = "󱄅";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          EndeavourOS = "";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
          Pop = "";
        };
      };
    };
  };
}
