{
  lib,
  config,
  homeConfig,
  ...
}: {
  options.nixconf.user = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "mcst";
      description = "Username";
    };

    home = lib.mkOption {
      type = lib.types.str;
      default = "/home/mcst";
      description = "User home path";
    };
  };

  config = {
    users.users.${config.nixconf.user.username} = {
      isNormalUser = true;
      home = config.nixconf.user.home;
      extraGroups = ["wheel" "video" "audio" "disk"];
      description = config.nixconf.user.username;
    };

    home-manager.users.${config.nixconf.user.username}.imports = [
      # TODO: Fix this properly
      ../home
      homeConfig
    ];
  };
}
