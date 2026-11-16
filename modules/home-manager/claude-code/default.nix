# Shared Claude Code config for every host. Host-specific layers live in
# personal.nix and work.nix and merge on top of this.
{ pkgs, config, ... }:
let
  claudeDir = config.programs.claude-code.configDir;
in
{
  programs.claude-code = {
    enable = true;

    # Claude Code is installed natively (auto-updating) on Linux and via the
    # package in hosts/emmiMBP/configuration.nix on the Mac; only manage config.
    package = null;

    # Merge the declared settings into a writable settings.json during
    # activation, so /config, /model etc. keep working inside Claude Code.
    # Declared values win on every switch; anything else Claude writes is kept.
    mutableSettings = true;

    settings = {
      model = "opus";
      theme = "auto";
      editorMode = "vim";
      alwaysThinkingEnabled = false;
      autoCompactEnabled = false;
      idleCompaction = false;

      modelSettings = {
        "claude-opus-5-5".effortLevel = "high";
        "claude-fable-5-2".effortLevel = "high";
      };

      permissions.deny = [
        "Artifact"
        "Workflow"
        "Agent"
        "PowerShell"
      ];

      statusLine = {
        type = "command";
        command = "${pkgs.python3}/bin/python3 ${./statusline.py}";
        padding = 0;
      };

      enabledPlugins = {
        "rust-analyzer-lsp@claude-plugins-official" = false;
        "cc-plugin-diff@builtin" = false;
        "cc-plugin-easel@builtin" = false;
        "cc-plugin-plugin-authoring@builtin" = false;
      };
    };
  };

  # home-manager has no option for keybindings.json.
  home.file."${claudeDir}/keybindings.json".source = ./keybindings.json;
}
