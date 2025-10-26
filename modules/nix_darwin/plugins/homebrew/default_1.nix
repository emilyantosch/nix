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
      "firefox"
      "chromium"
      "visual-studio-code"
      "docker-desktop"
      "ghostty"

      "discord"

      "raycast"

      "postman"

      "aerospace"
    ];
  };
}
