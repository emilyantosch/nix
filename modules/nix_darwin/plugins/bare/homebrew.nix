{ pkgs, ... }:
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
      "llvm"
      "cmake"
      "openjdk"
      "fish"
      "awscli"
      "helm"
      "imagemagick"
      "git"
      "bacon"
      "bacon-ls"
      "scip"
      "grpcurl"
      "ghz"
      "jira-cli"
      "yt-dlp"
      "mpv"
      "ncspot"
    ];

    casks = [
      "sioyek"
      "google-chrome"
      "microsoft-teams"
      "microsoft-powerpoint"
      "microsoft-outlook"
      "microsoft-excel"
      "obsidian"
      "ghostty"
      "karabiner-elements"
      "zen"
      "intellij-idea"
      "alacritty"

      "discord"

      "raycast"

      "spotify"
      "postman"
      "audiowhisper"
    ];
  };
}
