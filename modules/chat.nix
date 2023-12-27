{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.chat = {
    telegram = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Telegram Desktop";
    };
    discord = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Discord";
    };
    slack = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Slack";
    };
    teams = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Teams";
    };
  };

  config = {
    home-manager.users.${config.nixconf.user} = {
      home.packages = lib.lists.flatten [
        (lib.lists.optional config.nixconf.chat.telegram pkgs.tdesktop)
        (lib.lists.optional config.nixconf.chat.teams pkgs.teams)
        (lib.lists.optional config.nixconf.chat.slack pkgs.slack)
        (lib.lists.optional config.nixconf.chat.discord pkgs.discord)
      ];
    };
  };
}
