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
      "aws-sso-cli"
      "awscurl"
      "fd"
      "wget"
      "bat"
      "curl"
      "opencode"
      "node"
      "gpg"
      "deno"
      "typst"
      "llvm"
      "cmake"
      "PeonPing/tap/peon-ping"
      "openjdk"
      "fish"
      "ollama"
      "awscli"
      "lld"
      "sesh"
      "television"
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
      "worktrunk"
      "sem-cli"
      "eugene1g/safehouse/agent-safehouse"
    ];

    casks = [
      "sioyek"
      "claude-code@latest"
      "antinote"
      "google-chrome"
      "microsoft-teams"
      "microsoft-powerpoint"
      "zed"
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
