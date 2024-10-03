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
    ./filesystem.nix
    ./network.nix
    ./peripherals.nix
    ./printer.nix
    ./flatpak.nix
    ./kanata.nix
    ./locale.nix
    ./security.nix
    ./fhs.nix
    ./gaming.nix

    ./graphics
    ./desktop

    ./term
    ./dev
    ./theme.nix
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

    # Install NH CLI for better Nix experience
    environment.systemPackages = [
      pkgs.nh
      pkgs.nvd
      pkgs.nix-output-monitor

      # Basic must-have utilities
      pkgs.coreutils-full
      pkgs.curl
      pkgs.wget
      pkgs.lsof
      pkgs.pciutils
      pkgs.lshw
      pkgs.gzip
      pkgs.unzip
      pkgs.xdg-utils
    ];

    # Setup flake path for NH CLI
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
  };
}
