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
      default = "24.11";
      description = "Nix State Version";
    };
  };

  config = {
    nixpkgs = {
      overlays =
        lib.attrsets.attrValues outputs.overlays
        ++ [
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

    nix = {
      # Nix CLI version
      package = lib.mkDefault pkgs.nixVersions.latest;

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

      # Setup nixd point flake input `nixpkgs`
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    };

    # setup completion links
    environment.pathsToLink = ["/share/bash-completion" "/share/fish"];

    # install basic utilities
    environment.systemPackages = [
      pkgs.coreutils-full
      pkgs.gnumake
      pkgs.gzip
      pkgs.tree
      pkgs.curl
      pkgs.wget
      pkgs.htop
      pkgs.file
      pkgs.dig
      pkgs.htop
      pkgs.file
      pkgs.dig
    ];
  };
}
