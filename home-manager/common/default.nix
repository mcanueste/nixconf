{
  inputs,
  outputs,
  pkgs,
  lib,
  config,
  isStandalone ? true,
  ...
}: {
  imports = [
    ./editor
    ./scripts
    ./shell
    ./term
    ./packages

    ./browsers.nix
    ./chat.nix
    ./git.nix
    ./media.nix
    ./theme.nix
  ];

  options.nixconf = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "mcst";
      description = "Username";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = "24.05";
      description = "Nix State Version";
    };

    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.nixconf.username}/nixconf";
      description = "Full path to flake for NH CLI";
    };

    isStandalone = pkgs.libExt.mkEnabledOption "Standalone Home Configuration?";
  };

  config = {
    nixpkgs = lib.mkIf isStandalone {
      overlays =
        lib.attrsets.attrValues outputs.overlays
        ++ [
          # You can also add overlays exported from other flakes:
          # inputs.nixgl.overlays.default # install packages directly from outputs instead
        ];

      config = {
        allowUnfree = true;
      };
    };

    home = {
      username = config.nixconf.username;
      homeDirectory = "/home/${config.nixconf.username}";
    };

    # Set state version, not really important as we are using flakes,
    home.stateVersion = config.nixconf.stateVersion;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    nix = lib.mkIf isStandalone {
      # Nix CLI version
      package = lib.mkDefault pkgs.nixVersions.latest;

      # Run garbage collection daily (for home profile)
      gc = {
        automatic = true;
        frequency = "daily";
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

        # Add user to the trusted users
        trusted-users = [config.nixconf.username];
      };

      # flake registry defaults to nixpkgs (unstable in this case)
      registry.nixpkgs.flake = inputs.nixpkgs;
    };

    # if standalone install, setup nixgl
    nixGL = lib.mkIf isStandalone {
      packages = inputs.nixgl.packages;
      defaultWrapper = "mesa";
      offloadWrapper = "nvidiaPrime";
      installScripts = ["mesa" "nvidiaPrime"];
    };

    # Enable settings to make it work better on standalone hm installations
    targets.genericLinux.enable = isStandalone;

    # Add nix installed apps to desktop on standalone hm installations
    xdg = lib.mkIf isStandalone {
      mime.enable = true;
      systemDirs.data = ["/home/${config.nixconf.username}/.nix-profile/share/applications"];
    };

    # Set flakes path for nh
    home.sessionVariables.FLAKE = config.nixconf.flakePath;
    home.packages = pkgs.libExt.filterNull [
      # Better nix tools
      pkgs.nh
      pkgs.nvd
      pkgs.nix-output-monitor
      pkgs.manix

      # also install home-manager and nixgl if standalone hm install
      (pkgs.libExt.mkIfElseNull isStandalone pkgs.home-manager)
    ];
  };
}
