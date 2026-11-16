# Shared pi coding agent config for every host. personal.nix layers on top.
#
# Not using home-manager's programs.pi-coding-agent: it links settings.json
# read-only, and pi writes to it (lastChangelogVersion, /settings changes).
# Instead each file in `pi.files` is merged into a writable copy on activation,
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
        defaultThinkingLevel = "xhigh";
        theme = "gruvbox-dark-hard";
        packages = [
          "git:https://github.com/hasit/pi-community-themes"
          "npm:pi-ponytail"
          "npm:@juicesharp/rpiv-ask-user-question"
          "npm:pi-web-access"
          "npm:pi-nvim"
          "npm:pi-atuin"
          "npm:@narumitw/pi-usage"
        ];
      };

      "extensions/guardrails.json" = {
        "$schema" = "https://unpkg.com/@aliou/pi-guardrails@0.15.0/schema.json";
        applyBuiltinDefaults = true;
        version = "0.13.0-20260619";
        onboarding = {
          completed = true;
          version = "0.13.0-20260619";
        };
        features = {
          permissionGate = true;
          policies = true;
        };
        permissionGate.patterns = [
          {
            pattern = "curl";
            description = "WebAccess (curl)";
            regex = true;
          }
          {
            pattern = "wget";
            description = "WebAccess (wget)";
            regex = true;
          }
          {
            pattern = "rm -rf";
            description = "Recursive deletion";
            regex = true;
          }
        ];
        policies.rules = [
          {
            id = "secret-files";
            name = "Secret files";
            description = "";
            patterns = [
              {
                pattern = ".env";
                regex = true;
              }
            ];
            protection = "readOnly";
            onlyIfExists = true;
            enabled = true;
          }
        ];
      };
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
