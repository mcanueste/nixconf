{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    gimp = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GIMP";
    };
  };

  config = lib.mkIf config.nixconf.media.gimp {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [pkgs.gimp];
    };
  };
}
