{ ... }:
{
  programs.vesktop = {
    enable = true;
    # Merge vencord.settings into a writable file instead of a read-only store
    # symlink; Vencord writes its settings on startup and fails with EROFS otherwise.
    vencord.mutableSettings = true;
    # caelestia (enableDiscord in cli.json) writes themes/caelestia.theme.css on
    # every scheme change; Vencord watches the themes dir and reloads it live.
    vencord.settings = {
      enabledThemes = [ "caelestia.theme.css" ];
      # QuickCSS loads on top of the themes and still holds an old gruvbox theme.
      useQuickCss = false;
    };
  };
}
