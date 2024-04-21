{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    easyeffects = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Easy Effects";
    };

    qpwgraph = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable qpwgraph";
    };

    audacity = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Audacity";
    };

    vlc = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable VLC";
    };

    spotify = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Spotify";
    };
  };

  config = {
    home-manager.users.${config.nixconf.user} = {
      home.packages = lib.lists.flatten [
        # TODO setup deepfilternet noise cancelling for mics
        (
          if config.nixconf.media.easyeffects
          then pkgs.easyeffects
          else []
        )
        (
          if config.nixconf.media.qpwgraph
          then pkgs.qpwgraph
          else []
        )
        (
          if config.nixconf.media.audacity
          then pkgs.audacity
          else []
        )
        (
          if config.nixconf.media.vlc
          then pkgs.vlc
          else []
        )
        (
          if config.nixconf.media.spotify
          then pkgs.spotify
          else []
        )
      ];
    };
  };
}
