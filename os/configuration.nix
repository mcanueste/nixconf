# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Import home manager configs
      ../home/home.nix
    ];


  ############################## Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    # TODO add plymouth?
  };


  ############################## Hardware
  hardware = {
    # Use pipewire
    pulseaudio.enable = false;

    # enable udev rules for zsa keybords
    keyboard.zsa.enable = true;

    # nvidia driver
    opengl.enable = true;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


  ############################## System.
  sound.enable = true; # disable sound as we are using pipewire


  ############################## Security.
  security.rtkit.enable = true;


  ############################## Locale
  # Set your time zone.
  time.timeZone = "Europe/Berlin";
 
  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.utf8";
 
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.utf8";
      LC_IDENTIFICATION = "de_DE.utf8";
      LC_MEASUREMENT = "de_DE.utf8";
      LC_MONETARY = "de_DE.utf8";
      LC_NAME = "de_DE.utf8";
      LC_NUMERIC = "de_DE.utf8";
      LC_PAPER = "de_DE.utf8";
      LC_TELEPHONE = "de_DE.utf8";
      LC_TIME = "de_DE.utf8";
    };
  };


  ############################## Networking.
  networking = {
    hostName = "nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enable networking
    networkmanager.enable = true;

    # Configure network proxy if necessary
    # proxy = {
      # default = "http://user:password@proxy:port/";
      # noProxy = "127.0.0.1,localhost,internal.domain";
    # };

    # firewall = {
      # Open ports in the firewall.
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];

      # Or disable the firewall altogether.
      # enable = false;
    # };
  };


  ############################## Services.
  services = {
    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      pulse.enable = true;

      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      wireplumber.enable = true;
    };

    # X11
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Configure keymap in X11
      layout = "us";
      xkbVariant = "";

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;

      # nvidia
      videoDrivers = [ "nvidia" ];
    };
  };


  ############################## User.
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mcst = {
    isNormalUser = true;
    description = "mcst";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

   
  ############################## Packages.
  virtualisation = {
    docker.enable = true;
    podman = {
      enable = true;
      dockerCompat = false;
    };
    virtualbox = {
      host = {
        enable = true;
	enableExtensionPack = true;
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ 
    # General
    git
    wget
    htop

    # Browser
    firefox
    brave
    
    # Virtualization tools
    docker-compose
    podman-compose

    # Editors
    neovim
    jetbrains.pycharm-professional

    # Communication
    teams

    # Wally for moonlander
    wally-cli
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # enable experimental and unfree packages for user
  nix.extraOptions = ''
    experimental-features = nix-command
  '';

  ############################## Version.
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
