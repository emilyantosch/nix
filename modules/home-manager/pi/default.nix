# Shared pi coding agent config for every host. personal.nix layers on top.
#
# Not using home-manager's programs.pi-coding-agent: it links settings.json
# read-only, and pi writes to it (lastChangelogVersion, /settings changes).
# Instead each JSON file in `pi.files` is merged into a writable copy on activation,
# the same way programs.claude-code.mutableSettings does it: declared keys win
# on every switch, anything else pi writes is kept.
#
# pi itself is installed by its own managed installer (~/.pi/agent/bin/pi).
# Auth (auth.json, models-store.json), trust.json and installed packages are
# app state and stay unmanaged; pi installs `packages` on its own.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  json = pkgs.formats.json { };
  agentDir = "${config.home.homeDirectory}/.pi/agent";
in
{
  options.pi.files = lib.mkOption {
    type = lib.types.attrsOf json.type;
    default = { };
    description = "JSON files under ~/.pi/agent, keyed by relative path, merged into writable copies on activation.";
  };

  config = {
    pi.files = {
      "settings.json" = {
        defaultThinkingLevel = "high";
        theme = "gruvbox-dark-hard";
        collapseChangelog = true;
        quietStartup = true;
        powerline = "compact";
        tuiMode = "fullscreen";
        compaction.enabled = false;
        extensions = [
          "-extensions/pi-gondolin/index.ts"
          "-builtin:mcp"
        ];
        packages = [
          "git:https://github.com/hasit/pi-community-themes"
          "npm:@aliou/pi-guardrails"
          "npm:pi-ponytail"
          "npm:@juicesharp/rpiv-ask-user-question"
          "npm:pi-web-access"
          "npm:pi-nvim"
          "npm:pi-atuin"
          "npm:@narumitw/pi-usage"
        ];
      };

      "extensions/guardrails.json" = lib.importJSON ./guardrails.json;
    };

    # Read-only for pi, so plain links. Prompts are shared with the Claude skills.
    home.file = {
      ".pi/agent/APPEND_SYSTEM.md".source = ./APPEND_SYSTEM.md;
      ".pi/agent/prompts/commit-push-pr.md".source = ../claude-code/skills/commit-push-pr.md;
      ".pi/agent/prompts/local-review.md".source = ../claude-code/skills/local-review.md;
    };

    home.activation.piConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] (
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          name: value:
          lib.hm.generators.mkImpureConfigMerger {
            inherit pkgs;
            path = "${agentDir}/${name}";
            staticSettings = json.generate "pi-${baseNameOf name}" value;
            format = "json";
            empty = "{}";
            jqOperation = ''if ($dynamic | type) == "object" and ($static | type) == "object" then $dynamic * $static else error("expected JSON objects") end'';
          }
        ) config.pi.files
      )
    );
  };
}
