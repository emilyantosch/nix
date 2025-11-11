{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = {
      v = "nvim";
      ll = "eza -1 -l";
      g = "git";
      nxd = "sudo nixos-rebuild switch --upgrade --flake /home/emmi/.config/nixos/#default";
      nxe = "sudo darwin-rebuild switch --flake ~/.config/nix/#emmiMBP";
      nxea = "sudo darwin-rebuild switch --flake ~/.config/nix/#emilyantoschMBP";
      y = "yazi";
    };

    envFile.text = ''
      $env.PATH = [
      $"($env.HOME)/.nix-profile/bin"
      $"/etc/profiles/per-user/($env.USER)/bin"
      "/run/wrappers/bin"
      "/run/current-system/sw/bin"
      "/bin"
      "/sbin"
      "/usr/bin"
      "/usr/sbin"
      "/usr/local/bin"
      "/nix/var/nix/profiles/default/bin"
      ]
      $env.editor = "nvim"
      ${pkgs.zoxide}/bin/zoxide init nushell | save -f ~/.zoxide.nu
    '';
    configFile.text = ''
      source ~/.zoxide.nu
    '';
    plugins = [ ];
  };
}
