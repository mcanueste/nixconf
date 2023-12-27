{
  homeConfig,
  lib,
  config,
  ...
}: {
  options.nixconf = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "mcst";
      description = "Username";
    };
  };

  config = {
    users.users.${config.nixconf.user} = {
      isNormalUser = true;
      home = "/home/${config.nixconf.user}";
      extraGroups = ["wheel" "video" "audio" "disk"];
    };

    home-manager.users.${config.nixconf.user} = {
      programs.home-manager.enable = true;
      home = {
        stateVersion = "24.05";
        username = config.nixconf.user;
        homeDirectory = "/home/${config.nixconf.user}";
      };
      # imports = [
      #   # TODO: remove this after moving to modules fully
      #   ./home
      #   homeConfig
      # ];
    };
  };
}
