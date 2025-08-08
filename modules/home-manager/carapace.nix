{ pkgs, ... }:
{
  # Configured over normal module not home-manager
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
