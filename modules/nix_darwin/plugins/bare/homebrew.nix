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
      "mole"
      "awscurl"
      "fd"
      "wget"
      "bat"
      "curl"
      "node"
      "gpg"
      "typst"
      "llvm"
      "cmake"
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
      "scip"
      "grpcurl"
      "ghz"
      "gh"
      "jira-cli"
      "yt-dlp"
      "mpv"
      "mise"
      "yq"
      "go"
      "jsonnet"
      "git-lfs"
      "uv"
      "glib"
      "openssl"
      "pkgconf"
      "gtk+3"
      "atkmm"
      "tree-sitter-cli"
      "nvim"
      "worktrunk"
      "sem-cli"
      "eugene1g/safehouse/agent-safehouse"
      "postgresql@18"
      "googleworkspace-cli"
      "tuicr"
    ];

    casks = [
      "godot"
      "audacity"
      "chatgpt"
      "zed"
      "sioyek"
      "utm"
      "helium-browser"
      "claude-code@latest"
      "microsoft-teams"
      "microsoft-powerpoint"
      "microsoft-outlook"
      "microsoft-excel"
      "obsidian"
      "ghostty"
      "karabiner-elements"
      "zen"
      "discord"
      "raycast"
      "spotify"
      "handy"
    ];
  };
}
