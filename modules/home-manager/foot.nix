{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs = {
    foot = {
      enable = true;
      theme = "gruvbox";
      settings = {
        font = [
          "JetBrainsMono NFM:size=18:weight=bold:slant=italic"
        ];
        main = {
          selection-target = "both";
        };
        # colors.alpha = 0.7;
        # colors.alpha-mode = "all";
      };

    };
  };
}
