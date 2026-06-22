{ pkgs, ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
      extraFlags = [ "--force-cleanup" ];
    };

    brews = [
      "aws-sso-cli"
      "mole"
      "jj"
      "gws"
      "awscurl"
      "fd"
      "wget"
      "bat"
      "curl"
      "opencode"
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
      "bacon-ls"
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
      "presenterm"
      "nvim"
      "worktrunk"
      "sem-cli"
      "eugene1g/safehouse/agent-safehouse"
      "rtk"
      "postgresql@18"
    ];

    casks = [
      "wispr-flow"
      "sioyek"
      "codex"
      "claude-code@latest"
      "antinote"
      "google-chrome"
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
      "pgadmin4"
    ];
  };
}
