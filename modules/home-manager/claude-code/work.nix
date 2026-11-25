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
        ];
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
