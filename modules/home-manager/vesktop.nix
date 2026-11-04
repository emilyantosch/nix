{ ... }:
{
  programs.vesktop = {
    enable = true;
    # caelestia (enableDiscord in cli.json) writes themes/caelestia.theme.css on
    # every scheme change; Vencord watches the themes dir and reloads it live.
    vencord.settings = {
      enabledThemes = [ "caelestia.theme.css" ];
      # QuickCSS loads on top of the themes and still holds an old gruvbox theme.
      useQuickCss = false;
    };
  };
}
