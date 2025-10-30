{pkgs, ...}:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    masApps = {
      Xcode = 497799835;
    };

    brews = [
      "wget"
      "curl"
      "opencode"
    ];

    casks = [
      "chromium"
      "obsidian"
      "docker-desktop"
      "ghostty"
      "karabiner-elements"
      "zen"
      "intellij-idea"

      "discord"

      "raycast"

      "postman"
    ];
  };
}
