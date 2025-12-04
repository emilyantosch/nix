{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = {
      vi = "nvim";
      ll = "eza -1 -l";
      yz = "yazi";

      # Nix Aliases
      nd = "sudo nixos-rebuild switch --upgrade --flake /home/emmi/.config/nixos/#default";
      ne = "sudo darwin-rebuild switch --flake ~/.config/nix/#emmiMBP";
      na = "sudo darwin-rebuild switch --flake ~/.config/nix/#emilyantoschMBP";

      # Git Aliases
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gf = "git fetch";
      gp = "git pull";
      gP = "git push";
      gb = "git branch";
      gC = "git checkout";
      gm = "git merge";
      gr = "git rebase";
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
      "/Users/emilylucia.antosch/.cargo/bin"
      "/opt/homebrew/bin/"
      ]
      $env.CARGO_NET_GIT_FETCH_WITH_CLI = "true"
      $env.editor = "nvim"
      ${pkgs.zoxide}/bin/zoxide init nushell | save -f ~/.zoxide.nu
      $env.DISPLAY = ":0"
      mkdir $"($nu.cache-dir)"
      carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
    '';
    loginFile.text = ''
    do --env {
        let ssh_agent_file = (
            $nu.temp-path | path join $"ssh-agent-(whoami).nuon"
        )

    if ($ssh_agent_file | path exists) {
        let ssh_agent_env = open ($ssh_agent_file)
        if ($"/proc/($ssh_agent_env.SSH_AGENT_PID)" | path exists) {
            load-env $ssh_agent_env
            return
        } else {
            rm $ssh_agent_file
        }
    }

    let ssh_agent_env = ^ssh-agent -c
        | lines
        | first 2
        | parse "setenv {name} {value};"
        | transpose --header-row
        | into record
    load-env $ssh_agent_env
    $ssh_agent_env | save --force $ssh_agent_file
}
    '';
    configFile.text = ''
      source ~/.zoxide.nu
      source $"($nu.cache-dir)/carapace.nu"
    '';
    plugins = [ ];
  };
}
