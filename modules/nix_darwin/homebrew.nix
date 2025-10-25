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
    ];

    casks = [
      "firefox"
      "google-chrome"
      "visual-studio-code"

      "discord"

      "raycast"

      "postman"

      "aerospace"
    ];
  };
}
