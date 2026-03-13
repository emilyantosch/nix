{ ... }:
{
  programs.claude-code = {
    enable = true;
    package = null;

    commands = {
      local-review = ./commands/local-review.md;
    };
  };
}
