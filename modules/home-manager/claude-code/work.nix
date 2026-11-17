# Work Mac (emilyantoschMBP): MOIA setup layered on default.nix.
{ lib, ... }:
{
  imports = [ ./default.nix ];

  programs.claude-code = {
    skills = {
      local-review = ./skills/local-review.md;
      commit-push-pr = ./skills/commit-push-pr.md;
    };

    rules = {
      shell = ''
        Always use the fish shell for everything.
        All of the auth setup is done for fish only (git/ssh).
        Example: `git push` becomes `fish -c 'git push'`
      '';
    };

    settings = {
      # Provider (MOIA AI gateway: apiKeyHelper, env, marketplace) is merged
      # into settings.json by /opt/moia/claude-code/managed.cue, not here.
      autoMemoryEnabled = true;

      attribution = {
        commit = "";
        pr = "";
      };

      permissions = {
        allow = [
          "ToolSearch"
          "mcp__plugin_context7_context7__query-docs"
          "mcp__ide__getDiagnostics"
          "mcp__plugin_context7_context7__resolve-library-id"
          "Bash(grep:*)"
          "Bash(cargo audit:*)"
          "WebFetch"
          "Read"
          "Bash(find:*)"
          "Bash(ls:*)"
          "Bash(cp:*)"
          "Bash(cd:*)"
          "Bash(cargo build:*)"
          "Bash(cargo check:*)"
          "Bash(cargo test:*)"
          "Bash(cargo nextest:*)"
          "Bash(cargo tree:*)"
          "Bash(cargo clippy:*)"
          "Bash(cargo doc:*)"
          "Bash(just)"
          "Bash(just fmt:*)"
          "Bash(just lint:*)"
        ];
      };

      enabledPlugins = {
        "context7@claude-plugins-official" = true;
      };
      voiceEnabled = false;
      # Wins over MOIA's ai-gateway-budget-statusline on every switch.
      statusLine = lib.mkForce {
        type = "command";
        command = "bash ${./statusline-command.sh}";
        padding = 0;
      };
    };
  };
}
