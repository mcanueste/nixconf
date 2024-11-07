{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    spotify = lib.mkEnableOption "Spotify";
    vlc = lib.mkEnableOption "VLC";
    obs = lib.mkEnableOption "OBS";
    audacity = lib.mkEnableOption "Audacity";
    gimp = lib.mkEnableOption "GIMP";
    calibre = lib.mkEnableOption "Calibre";
    zotero = lib.mkEnableOption "Zotero";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.media.spotify pkgs.spotify)
      (pkgs.libExt.mkIfElseNull config.nixconf.media.vlc pkgs.stable.vlc)
      (pkgs.libExt.mkIfElseNull config.nixconf.media.obs pkgs.stable.obs-studio)
      (pkgs.libExt.mkIfElseNull config.nixconf.media.audacity pkgs.stable.audacity)
      (pkgs.libExt.mkIfElseNull config.nixconf.media.gimp pkgs.stable.gimp)
      (pkgs.libExt.mkIfElseNull config.nixconf.media.calibre pkgs.stable.calibre)
      (pkgs.libExt.mkIfElseNull config.nixconf.media.zotero pkgs.stable.zotero)
    ];
  };
}
