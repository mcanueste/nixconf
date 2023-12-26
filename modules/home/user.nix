{
  lib,
  config,
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
    home = {
      username = config.nixconf.user.username;
      homeDirectory = config.nixconf.user.home;
    };
  };
}
