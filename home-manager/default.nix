{
  lib,
  config,
  ...
}: {
  imports = [
    ./term
    ./shell
    ./editor
    ./scripts

    ./git.nix
    ./packages.nix
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
      default = "/home/${config.nixconf.username}/Projects/personal/nixconf";
      description = "Full path to flake for NH CLI";
    };
  };

  config = {
    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    home.stateVersion = config.nixconf.stateVersion;

    home.sessionVariables = {
      # Set FLAKE path for nh
      FLAKE = config.nixconf.flakePath;
    };
  };
}
