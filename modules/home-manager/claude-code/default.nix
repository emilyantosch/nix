{ ... }:
{
  programs.claude-code = {
    enable = true;
    package = null;

    commands = {
      local-review = ./commands/local-review.md;
    };

    skills = {
      test-driven-development = ./skills/test-driven-development.md;
    };
    settings = {

      env = {
        AWS_REGION = "eu-central-1";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "eu.anthropic.claude-opus-4-6-v1";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "eu.anthropic.claude-sonnet-4-6";
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "eu.anthropic.claude-haiku-4-5-20251001-v1:0";
        CLAUDE_CODE_USE_BEDROCK = "1";
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
    };
  };
}
