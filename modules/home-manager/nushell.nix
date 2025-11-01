{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = {
      v = "nvim";
      ll = "eza -1 -l";
      g = "git";
      nx = "sudo nixos-rebuild switch --upgrade --flake /home/emmi/.config/nixos/#default";
      y = "yazi";
    };

    envFile.text = ''
      $env.PATH = [
      $"($env.HOME)/.nix-profile/bin"
      $"/etc/profiles/per-user/($env.USER)/bin"
      "/run/current-system/sw/bin"
      "/bin"
      "/sbin"
      "/usr/bin"
      "/usr/sbin"
      "/usr/local/bin"
      "/nix/var/nix/profiles/default/bin"
      ]
      ${pkgs.zoxide}/bin/zoxide init nushell | save -f ~/.zoxide.nu
    '';
    configFile.text = ''
      source ~/.zoxide.nu
    '';
    plugins = [ ];
  };
}
