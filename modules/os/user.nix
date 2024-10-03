{
  lib,
  config,
  inputs,
  ...
}: let
  # not important since we use unstable via flake,
  # but need to give it here so the error msg is gone.
  stateVersion = "24.05";
in {
  options.nixconf.os = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "mcst";
      description = "Username";
    };
  };

  config = {
    system = {inherit stateVersion;};

    # User settings
    users.users.${config.nixconf.os.user} = {
      isNormalUser = true;
      home = "/home/${config.nixconf.os.user}";
      extraGroups = ["wheel" "video" "audio" "disk"];
    };

    # Home manager settings
    # TODO: move home manager configuration to separate dir along with this
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs;};
      users.${config.nixconf.os.user} = {
        programs.home-manager.enable = true;
        home = {
          inherit stateVersion;
          username = config.nixconf.os.user;
          homeDirectory = "/home/${config.nixconf.os.user}";
        };
      };
    };
  };
}
