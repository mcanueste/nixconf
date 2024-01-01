{
  lib,
  config,
  inputs,
  ...
}: let
  # not considered since we use unstable via flake,
  # but need to give it here so the error msg is gone.
  stateVersion = "24.05";
in {
  options.nixconf = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "mcst";
      description = "Username";
    };
  };

  config = {
    system = {inherit stateVersion;};

    # User settings
    users.users.${config.nixconf.user} = {
      isNormalUser = true;
      home = "/home/${config.nixconf.user}";
      extraGroups = ["wheel" "video" "audio" "disk"];
    };

    # Home manager settings
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs;};
      users.${config.nixconf.user} = {
        programs.home-manager.enable = true;
        imports = [inputs.gBar.homeManagerModules.x86_64-linux.default];
        home = {
          inherit stateVersion;
          username = config.nixconf.user;
          homeDirectory = "/home/${config.nixconf.user}";
        };
      };
    };
  };
}
