# Shared Claude Code config for every host. Host-specific layers live in
# personal.nix and work.nix and merge on top of this.
{ pkgs, config, ... }:
let
  claudeDir = config.programs.claude-code.configDir;
in
{
  programs.claude-code = {
    enable = true;

    # Claude Code is installed natively (auto-updating) on every host;
    # only manage config here.
    package = null;

    # Merge the declared settings into a writable settings.json during
    # activation, so /config, /model etc. keep working inside Claude Code.
    # Declared values win on every switch; anything else Claude writes is kept.
    mutableSettings = true;

    settings = {
      model = "opus";
      theme = "auto";
      editorMode = "vim";
      tui = "fullscreen";
      spinnerVerbs = {
        mode = "replace";
        verbs = [
          "Rolling for Initative"
          "Long Resting"
          "Casting Fireball"
          "Journeying"
          "Roleplaying"
          "Blessing"
          "Receiving Guidance"
          "Seducing a Dragon"
          "Action Surging"
          "Rolling a Death Save"
          "Being Lethargic"
          "Critting"
          "Rolling with Advantage"
          "Active Perception Check"
          "Nat20'ing"
          "Writing a Session Recap"
          "Not taking notes"
          "Snacking"
          "Forgetting my Dice"
          "Failing a Dexterity Check"
          "Critcially Failing"
        ];
      };
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
