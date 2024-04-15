{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.chat = {
    teams = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Teams";
    };
  };

  config = lib.mkIf config.nixconf.chat.teams {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.teams];
    };
  };
}
