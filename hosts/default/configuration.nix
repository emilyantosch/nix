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
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./../../modules/nixos/tailscale.nix
    ./../../modules/nixos/proton.nix
    ./../../modules/nixos/sddm.nix
    ./../../modules/nixos/smb.nix
    ./../../modules/nixos/niri.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
  '';
  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = "emmiNix"; # Define your hostname.
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    roboto
    source-sans
    font-awesome
  ];

  # Configure console keymap
  console.keyMap = "de";


  # Enable bluetooth, like wtf
  hardware.bluetooth.enable = true;
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;


  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "ens3";
    # Lazy IPv6 connectivity for the container
    enableIPv6 = true;
  };

  # Enable OpenGL
  hardware = {
    wooting = {
      enable = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # Load nvidia driver for Xorg and Wayland

  virtualisation.docker.enable = true;
  hardware.nvidia-container-toolkit = {
    enable = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.nushell;
    users.emmi = {
      isNormalUser = true;
      description = "Emmi";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "input"
        "uinput"
        "libvirtd"
        "docker"
      ];
      shell = pkgs.nushell;
      packages = with pkgs; [
        kdePackages.kate
        #  thunderbird
      ];
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "bak";
    users = {
      "emmi" = import ./home.nix;
    };
  };


  # Allow unfree packages
  nixpkgs.config.cudaSupport = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePrediacte = (_: true);

  security.wrappers."mount.cifs" = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "root";
    group = "root";
    setuid = true;
  };

  programs.dconf.enable = true;

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
  };

  security.pam.services.hyprlock = { };
  environment.systemPackages = with pkgs; [
    gnome-keyring # Implements the Secret Portal
    nautilus # Required for File Chooser from xdg-desktop-portal-gnome 47.0+
    inkscape
    sqlite
    libxcb
    libxcb-wm
    libxcb-util
    adwaita-icon-theme
    unixtools.netstat
    openssl.dev
    cura-appimage
    super-slicer
    audacity
    (callPackage ./../../packages/home-manager/claude-code/default.nix { })
    nvidia-container-toolkit
    just
    openssl.out
    inputs.qs-caelestia-shell.packages.${system}.default
    inputs.qs-caelestia-cli.packages.${system}.default
    virtualgl
    pkg-config
    vesktop
    killall
    swww
    nushell
    onlyoffice-desktopeditors
    nodePackages.prettier
    lua
    gnutls
    obs-studio
    hwinfo
    btop
    yazi
    xdg-utils
    librsvg
    cmake
    kdePackages.dolphin
    protonplus
    protontricks
    wootility
    hyprlock
    hypridle
    zathura
    godot_4
    #Might be broken, will need to reinstall later for Ascend: aseprite
    foot
    python313
    bun
    deno
    inputs.nyx.packages.${pkgs.system}.core
    gh
    docker
    typst
    lazydocker
    lazygit
    pandoc
    uv
    jdk
    starship
    zplug
    swappy
    grim
    slurp
    vim
    git
    wget
    fzf
    fd
    ripgrep
    kdePackages.qtmultimedia
    wayland
    hyprland
    nmap
    discord
    bluez
    bluez-tools
    ghostty
    chromium
    tmux
    obsidian
    rustc
    clippy
    rustfmt
    cargo
    nix-init
    gnupg
    pass-wayland
    zsh
    gcc13
    clipse
    wl-clipboard
    zoxide
    rust-analyzer
    overskride
    pavucontrol
    steam
    steam-run
    cudaPackages.cudatoolkit
    cudaPackages.cuda_opencl
    p7zip
    cudaPackages.cudnn
    xfce.thunar
    cudaPackages.libnpp
    vlc
    winetricks
    wine
    prismlauncher
    nix-ld
    sass
    davinci-resolve
    blender
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.nix-ld.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
