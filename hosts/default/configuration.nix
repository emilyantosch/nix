# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./../../modules/nixos/tailscale.nix
      ./../../modules/nixos/proton.nix
      ./../../modules/nixos/sddm.nix
      ./../../modules/nixos/smb.nix
      inputs.home-manager.nixosModules.default 
      ];
    
  # Bootloader.
    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
    };

  systemd.sleep.extraConfig = 
  ''
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
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable bluetooth, like wtf
  hardware.bluetooth.enable = true;
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


# Enable Hyprland
programs.hyprland.enable = true;

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
  services.xserver.videoDrivers = ["nvidia"];

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
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

nix.settings.experimental-features = ["nix-command" "flakes"];
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
  defaultUserShell = pkgs.zsh;
	  users.emmi = {
	    isNormalUser = true;
	    description = "Emmi";
	    extraGroups = [ "networkmanager" "wheel" "video" "input" "uinput" "libvirtd" "docker" ];
	    shell = pkgs.zsh;
	    packages = with pkgs; [
	      kdePackages.kate
	    #  thunderbird
    ];
  };
  };

  virtualisation.docker = {
    enable = true;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs;};
    backupFileExtension = "bak";
    users = {
      "emmi" = import ./home.nix;
    };
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #
security.wrappers."mount.cifs" = {
      program = "mount.cifs";
      source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
      owner = "root";
      group = "root";
      setuid = true;
    };

  
  security.pam.services.hyprlock = {};
  environment.systemPackages = with pkgs; [
    openssl.dev
    openssl.out
    (callPackage ./../../packages/home-manager/dioxus-cli/default.nix {})
    hyprpanel
    nautilus
    virtualgl
    pkg-config
    gnutls
    lmstudio
    osu-lazer-bin
    obs-studio
    helix
    btop
    yazi
    cmake
    kdePackages.dolphin
    protonplus
    protontricks 
    wootility
    markdownlint-cli2
    hyprlock
    hypridle
    zathura
    typst
    typst-fmt
    typst-lsp
    ollama
    docker
    lazydocker
    lazygit
    pandoc
    uv
    code-cursor
    spotify
    starship
    zplug
    swappy
    grim
    slurp
    tinymist
    vim 
    git
    wget
    fzf
    fd
    ripgrep
    kdePackages.qtmultimedia
    neovim
    wayland
    hyprland
    hyprpaper
    hyprcursor
    discord
    tailscale
    bluez
    bluez-tools
    kitty
    felix-fm
    ghostty
    chromium
    rofi
    tmux
    waybar
    obsidian
    rustup
    nix-init
    gnupg
    pass-wayland
    zsh
    gcc13
    clipse
    wl-clipboard
    zoxide
    rust-analyzer
    bacon
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
    #rocmPackages.llvm.llvm
    #rocmPackages.llvm.clang
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

  services = {
    openssh.enable = true;
    ollama = {
      enable = true;
      acceleration = "cuda";
    };
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
  system.stateVersion = "24.11"; # Did you read the comment?

}
