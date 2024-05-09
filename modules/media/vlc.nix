{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    vlc = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable VLC";
    };
  };

  config = lib.mkIf config.nixconf.media.vlc {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [pkgs.vlc];
    };
  };
}
