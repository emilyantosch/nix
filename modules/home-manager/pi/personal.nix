# Personal machines only (NixOS desktop, emmiMBP): default to the OpenAI Codex
# subscription.
{ ... }:
{
  imports = [ ./default.nix ];

  pi.files = {
    "settings.json" = {
      defaultProvider = "openai-codex";
      defaultModel = "gpt-5.6-sol";
    };
    "automode.json".autoMode.classifierModel = "openai-codex/gpt-5.6-luna";
  };
}
