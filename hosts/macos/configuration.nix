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
  imports = [
  ];

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

  # Allow unfree packages
  nixpkgs.config.cudaSupport = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePrediacte = (_: true);

  environment.systemPackages = with pkgs; [
    sqlite
    openssl.dev
    just
    openssl.out
    pkg-config
    nushell
    lua
    btop
    python313
    bun
    deno
    inputs.nyx.packages.${pkgs.system}.core
    # inputs.darwin-modules.modules.aarch64-darwin.bare
    gh
    lazygit
    pandoc
    uv
    starship
    zplug
    vim
    git
    fzf
    fd
    ripgrep
    tmux
    obsidian
    zoxide
    p7zip
    sass
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
  system.primaryUser = "emmi";

}
