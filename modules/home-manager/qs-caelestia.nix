{ pkgs, inputs, lib, config, ... }:
let
  caelestia-shell = import ../../packages/caelestia-shell {
    inherit inputs;
    system = pkgs.stdenv.hostPlatform.system;
  };

  # caelestia renders ~/.config/caelestia/templates/* here on every scheme change.
  themeDir = "${config.xdg.stateHome}/caelestia/theme";

  # theme.postHook: runs after every scheme change (wallpaper pick, next/prev,
  # dark/light) once the templates are rendered, to make the apps pick them up.
  themeHook = pkgs.writeShellApplication {
    name = "caelestia-theme-hook";
    runtimeInputs = [ pkgs.coreutils pkgs.diffutils pkgs.jq pkgs.procps pkgs.tmux pkgs.pywalfox-native ];
    text = ''
      # Obsidian only live-reloads snippets inside a vault (a symlink out of
      # the vault isn't watched), so copy the CSS into every known vault. The
      # snippet still has to be enabled once per vault: Settings → Appearance
      # → CSS snippets → caelestia, with the base theme set to "Adapt to system".
      obsidianVaults="${config.xdg.configHome}/obsidian/obsidian.json"
      if [ -f "$obsidianVaults" ]; then
        jq -r '.vaults[].path' "$obsidianVaults" | while IFS= read -r vault; do
          snippet="$vault/.obsidian/snippets/caelestia.css"
          if [ -d "$vault/.obsidian" ] && ! cmp -s "${themeDir}/obsidian.css" "$snippet"; then
            mkdir -p "$vault/.obsidian/snippets"
            cp "${themeDir}/obsidian.css" "$snippet" || true
          fi
        done
      fi

      # Spotify reads spicetify.css (see spicetify.nix); use this mode's mapping.
      ln -sfn "spicetify-''${SCHEME_MODE:-dark}.css" "${themeDir}/spicetify.css"

      # Zen's Pywalfox reads pywalfox.json (see zen-browser.nix). Its dark and
      # light modes take background/text from different palette slots, hence
      # one template per mode. Fails harmlessly when Zen isn't running.
      ln -sfn "pywalfox-''${SCHEME_MODE:-dark}.json" "${themeDir}/pywalfox.json"
      pywalfox "''${SCHEME_MODE:-dark}" >/dev/null 2>&1 || true
      pywalfox update >/dev/null 2>&1 || true

      # Ghostty reloads its config, including the theme's config-file, on SIGUSR2.
      pkill -USR2 -x '\.?ghostty(-wrappe)?' || true

      # tmux servers live under /tmp or $TMUX_TMPDIR depending on who started them.
      for sock in "/tmp/tmux-$UID"/* "''${XDG_RUNTIME_DIR:-/run/user/$UID}/tmux-$UID"/*; do
        if [ -S "$sock" ]; then
          tmux -S "$sock" source-file -q "${themeDir}/tmux.conf" || true
        fi
      done
    '';
  };

  cliConfig = lib.recursiveUpdate (lib.importJSON ../../foreign/caelestia/cli.json) {
    theme.postHook = lib.getExe themeHook;
  };

  # Starship has no includes, so its whole config (starship.nix) becomes a
  # template with the palette swapped for the scheme's colours. Material roles
  # rather than the named colours: those drop to ~2:1 contrast behind text in
  # light themes, these stay above ~4:1.
  starshipTemplate = (pkgs.formats.toml { }).generate "starship.toml" (
    config.programs.starship.settings
    // {
      palette = "caelestia";
      palettes.caelestia = lib.mapAttrs (_: colour: "#{{ ${colour}.hex }}") {
        color_user = "primary";
        color_user_fg = "onPrimary";
        color_directory = "secondary";
        color_directory_fg = "onSecondary";
        color_git = "tertiary";
        color_git_fg = "onTertiary";
        color_lang = "primaryContainer";
        color_lang_fg = "onPrimaryContainer";
        color_env = "surfaceContainerHighest";
        color_env_fg = "onSurface";
        color_env_accent = "primary";
        color_time = "surfaceContainer";
        color_time_fg = "onSurface";
        color_ok = "green";
        color_error = "red";
        color_vim_replace = "mauve";
        color_vim_visual = "yellow";
      };
    }
  );
in
{
  home.file.".config/caelestia/shell.json".source = ../../foreign/caelestia/shell.json;
  home.file.".config/caelestia/cli.json".text = builtins.toJSON cliConfig;
  home.file.".config/caelestia/templates" = {
    source = ../../foreign/caelestia/templates;
    recursive = true;
  };
  home.file.".config/caelestia/templates/starship.toml".source = starshipTemplate;

  # Colours come from the current caelestia scheme; the static theme in
  # ghostty.nix/tmux.nix only shows until the first scheme change.
  programs.ghostty.settings.config-file = "?${themeDir}/ghostty";
  # Starship reads its config on every prompt, so no reload needed.
  home.file.${config.programs.starship.configPath}.source =
    lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${themeDir}/starship.toml");
  programs.tmux.extraConfig = ''
    source-file -q ${themeDir}/tmux.conf
  '';

  # Run the shell under systemd so it comes back if Qt Wayland segfaults
  # when outputs flap during lock/sleep.
  systemd.user.services.caelestia-shell = {
    Unit = {
      Description = "Caelestia shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${caelestia-shell}/bin/caelestia-shell";
      Restart = "on-failure";
      RestartSec = 2;
      # Normally ~400M. If it runs away (it has hit 56G), get OOM-killed and
      # restarted instead of dragging the whole machine through swap.
      MemoryMax = "4G";
      MemorySwapMax = 0;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
