{
  inputs,
  outputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./boot.nix
    ./desktop.nix
    ./fhs.nix
    ./filesystem.nix
    ./flatpak.nix
    ./gaming.nix
    ./locale.nix
    ./network.nix
    ./peripherals
    ./printer.nix
    ./security.nix
    ./virtualisation.nix
  ];

  options.nixconf = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "mcst";
      description = "Username";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "Hostname";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = "24.05";
      description = "Nix State Version";
    };

    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.nixconf.username}/Projects/personal/nixconf";
      description = "Full path to flake for NH CLI";
    };

    isLaptop = lib.mkEnableOption "Is Laptop";
    isVM = lib.mkEnableOption "Is Virtual Machine";
    isServer = lib.mkEnableOption "Is Server";
  };

  config = {
    nixpkgs = {
      overlays = [
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.stable-packages
        outputs.overlays.lib

        # You can also add overlays exported from other flakes:
        # neovim-nightly-overlay.overlays.default
      ];

      config = {
        allowUnfree = true;
      };
    };

    # Set state version, not really important as we are using flakes,
    # but to stop messages about state version mismatch, we must have it.
    system.stateVersion = config.nixconf.stateVersion;

    # User settings
    users.users.${config.nixconf.username} = {
      isNormalUser = true;
      home = "/home/${config.nixconf.username}";
      extraGroups = ["wheel" "video" "audio" "disk"];
    };

    # Host settings
    networking.hostName = config.nixconf.hostname;

    # Setup flake path for NH CLI # TODO: move to home configs
    environment.sessionVariables.FLAKE = config.nixconf.flakePath;

    # Home manager settings
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs;};
      users.${config.nixconf.username} = {
        programs.home-manager.enable = true;
        home = {
          inherit (config.nixconf) stateVersion;
          username = config.nixconf.username;
          homeDirectory = "/home/${config.nixconf.username}";
        };
      };
    };

    nix = {
      # Nix CLI version
      package = pkgs.nixVersions.latest;

      # Optimise store daily
      optimise.automatic = true;

      # Run garbage collection daily
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 3d";
      };

      settings = {
        # Enable flakes
        experimental-features = ["nix-command" "flakes"];

        # Don't warn about dirty git state
        warn-dirty = false;

        # Optimize store after each build
        auto-optimise-store = false;

        # Avoid unwanted garbage collection when using nix-direnv
        keep-outputs = true;
        keep-derivations = true;

        # Custom package caches
        substituters = ["https://cosmic.cachix.org/"];
        trusted-public-keys = [
          "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        ];
      };

      # flake registry defaults to nixpkgs (unstable in this case)
      registry.nixpkgs.flake = inputs.nixpkgs;
    };

    environment.systemPackages = [
      # Install `nh` for better nix experience
      pkgs.nh
      pkgs.nvd
      pkgs.nix-output-monitor
      pkgs.manix

      # basic utilities
      pkgs.coreutils-full
      pkgs.curl
      pkgs.wget
      pkgs.gzip
      pkgs.unzip
      pkgs.dash
      pkgs.lsof
      pkgs.lshw
      pkgs.gnumake
      pkgs.pciutils
      pkgs.xdg-utils
      pkgs.rsync
      pkgs.tree
      pkgs.fd
      pkgs.ripgrep
      pkgs.htop
      pkgs.ncdu
      pkgs.file
      pkgs.jq
      pkgs.dig
      pkgs.traceroute
      pkgs.hyperfine
      pkgs.entr
      pkgs.ffmpegthumbnailer
      pkgs.just
      pkgs.fastfetch
      pkgs.glow
    ];
  };
}
