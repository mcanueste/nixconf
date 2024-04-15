{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.chat = {
    telegram = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Telegram Desktop";
    };
  };

  config = lib.mkIf config.nixconf.chat.telegram {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.tdesktop];
    };
  };
}
