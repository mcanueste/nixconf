{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.chat = {
    discord = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Discord";
    };
  };

  config = lib.mkIf config.nixconf.chat.discord {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [pkgs.discord];
    };
  };
}
