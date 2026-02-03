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
      "awscurl"
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
      "ollama"
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
      "mise"
      "yq"
      "go"
      "jsonnet"
      "git-lfs"
      "ncspot"
      "uv"
      "glib"
      "openssl"
      "pkgconf"
      "gtk+3"
      "atkmm"
      "tree-sitter-cli"
      "presenterm"
      "nvim"
    ];

    casks = [
      "sioyek"
      "google-chrome"
      "microsoft-teams"
      "microsoft-powerpoint"
      "zed"
      "microsoft-outlook"
      "logi-options+"
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
