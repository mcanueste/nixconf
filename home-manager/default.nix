{
  lib,
  config,
  ...
}: {
  imports = [
    ./editor
    ./term
    ./git.nix
    ./packages.nix
    ./systemd.nix
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
  };

  config = {
    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    home.stateVersion = config.nixconf.stateVersion;
  };
}
