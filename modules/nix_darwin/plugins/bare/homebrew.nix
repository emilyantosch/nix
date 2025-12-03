{pkgs, ...}:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };


    brews = [
      "wget"
      "curl"
      "opencode"
      "node"
      "gpg"
      "deno"
      "typst"
    ];

    casks = [
      "google-chrome"
      "microsoft-teams"
      "microsoft-outlook"
      "obsidian"
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
