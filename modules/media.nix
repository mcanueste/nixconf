{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    spotify = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Spotify";
    };

    zotero = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Zotero";
    };

    calibre = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Calibre";
    };
  };

  config = {
    home-manager.users.${config.nixconf.user} = {
      home.packages = lib.lists.flatten [
        (lib.lists.optional config.nixconf.media.spotify pkgs.spotify)
        (lib.lists.optional config.nixconf.media.zotero pkgs.zotero)
        (lib.lists.optional config.nixconf.media.calibre pkgs.calibre)
      ];
    };
  };
}
