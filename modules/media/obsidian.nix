{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    obsidian = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Obsidian";
    };
  };

  config = lib.mkIf config.nixconf.media.obsidian {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [pkgs.obsidian];
    };
  };
}
