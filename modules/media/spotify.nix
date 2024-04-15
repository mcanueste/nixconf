{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    spotify = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Spotify";
    };
  };

  config = lib.mkIf config.nixconf.media.spotify {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.spotify];
    };
  };
}
