# Personal machines only (NixOS desktop, emmiMBP): default to the OpenAI Codex
# subscription.
{ ... }:
{
  imports = [ ./default.nix ];

  pi.files = {
    "settings.json" = {
      defaultProvider = "anthropic";
      defaultModel = "claude-opus-5-5";
    };
  };
}
