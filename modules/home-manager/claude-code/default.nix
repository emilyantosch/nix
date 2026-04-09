{ ... }:
{
  programs.claude-code = {
    enable = true;

    package = null;

    skills = {
      local-review = ./skills/local-review.md;
      commit-push-pr = ./skills/commit-push-pr.md;
      test-driven-development = ./skills/test-driven-development.md;
    };

    rules = {
      shell = ''
        Always use the fish shell for everything.
        All of the auth setup is done for fish only (git/ssh).
        Example: `git push` becomes `fish -c 'git push'`
      '';
    };

    settings = {
      autoMemoryEnabled = true;
      env = {
        AWS_REGION = "eu-central-1";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "eu.anthropic.claude-opus-4-6-v1";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "eu.anthropic.claude-sonnet-4-6";
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "eu.anthropic.claude-haiku-4-5-20251001-v1:0";
        CLAUDE_CODE_USE_BEDROCK = "1";
      };

      attribution = {
        commit = "";
        pr = "";
      };

      permissions = {
        allow = [
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

      model = "opus";
      hooks = {
        SessionStart = [
          {
            hooks = [
              {
                type = "command";
                command = "/Users/emilylucia.antosch/.claude/hooks/peon-ping/peon.sh";
                timeout = 10;
                async = true;
              }
            ];
          }
        ];
        PermissionRequest = [
          {
            hooks = [
              {
                type = "command";
                command = "/Users/emilylucia.antosch/.claude/hooks/peon-ping/peon.sh";
                timeout = 10;
                async = true;
              }
            ];
          }
        ];
        SessionEnd = [
          {
            hooks = [
              {
                type = "command";
                command = "/Users/emilylucia.antosch/.claude/hooks/peon-ping/peon.sh";
                timeout = 10;
                async = true;
              }
            ];
          }
        ];
        PreToolUse = [
          {
            hooks = [
              {
                type = "command";
                command = "npx -y ccstatusline@latest --hook";
              }
            ];
            matcher = "Skill";
          }
        ];
        UserPromptSubmit = [
          {
            hooks = [
              {
                type = "command";
                command = "npx -y ccstatusline@latest --hook";
              }
              {
                type = "command";
                command = "/Users/emilylucia.antosch/.claude/hooks/peon-ping/peon.sh";
                timeout = 10;
                async = true;
              }
            ];
          }
        ];
      };
      enabledPlugins = {
        "context7@claude-plugins-official" = true;
        "rust-analyzer-lsp@claude-plugins-official" = true;
      };
      voiceEnabled = false;
      statusLine = {
        type = "command";
        command = "npx -y ccstatusline@latest";
        padding = 0;
      };
    };
  };
}
