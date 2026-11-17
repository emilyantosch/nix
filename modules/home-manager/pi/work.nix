# Work Mac (emilyantoschMBP): default to the MOIA AI gateway. Layered on default.nix.
{ ... }:
{
  imports = [ ./default.nix ];

  pi.files."settings.json" = {
    defaultProvider = "moia-ai-gateway";
    defaultModel = "claude-opus-5-5";
    packages = [ "git:git@github.com:moia-playground/pi-moia-ai-gateway-provider" ];
  };
}
