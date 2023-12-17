{
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.user;
in {
  options.nixhome.user = {
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
    home.username = cfg.username;
    home.homeDirectory = cfg.home;
  };
}
