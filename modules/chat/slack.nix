{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.chat = {
    slack = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Slack";
    };
  };

  config = lib.mkIf config.nixconf.chat.slack {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [pkgs.slack];
    };
  };
}
