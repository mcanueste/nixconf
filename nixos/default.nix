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
    ./graphics
    ./common
    ./home
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
  };
}
