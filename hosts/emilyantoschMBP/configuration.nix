# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  lib,
  system,
  ...
}:
{
  # Bootloader.
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    roboto
    source-sans
    font-awesome
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.zsh.enable = true;

  users.users."emilylucia.antosch" = {
    name = "emilylucia.antosch";
    home = "/Users/emilylucia.antosch";
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePrediacte = (_: true);

  environment.systemPackages = with pkgs; [
    sqlite
    lazygit
    openssl.dev
    just
    openssl.out
    pkg-config
    lua
    nushell
    btop
    nixfmt
    python313
    aws-sso-cli
    docker_25
    podman
    bun
    deno
    inputs.nyx.packages.${pkgs.system}.core
    (callPackage ./../../packages/home-manager/claude-code/default.nix { })
    gh
    lazygit
    hadolint
    pandoc
    eza
    uv
    starship
    zplug
    vim
    git
    fzf
    fd
    ripgrep
    pass
    tmux
    zoxide
    p7zip
    sass
    sops
    jq
    kubectl
    delta
    scala
    rust-analyzer
    k9s
    emacs
    colima
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  # List services that you want to enable:
  services = {
    openssh.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = 6; # Did you read the comment?
  system.primaryUser = "emilylucia.antosch";

}
