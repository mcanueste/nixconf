{
  pkgs-stable,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    calibre = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Calibre";
    };
  };

  config = lib.mkIf config.nixconf.media.calibre {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [pkgs-stable.calibre];
    };
  };
}
