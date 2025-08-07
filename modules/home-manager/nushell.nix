{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = {
      v = "nvim";
      ll = "eza -1 -l";
      g = "git";
      nxd = "sudo nixos-rebuild switch --upgrade --flake /home/emmi/.config/nixos/#default";
      y = "yazi";
    };
    envFile.text = ''
      zoxide init nushell | save -f ~/.zoxide.nu
    '';
    configFile.text = ''
      source ~/.zoxide.nu
    '';
    plugins = [ ];
  };
}
