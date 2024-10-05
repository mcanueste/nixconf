{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.flatpak = {
    brave = lib.mkEnableOption "Brave";

    chrome = lib.mkEnableOption "Chrome";

    firefox = lib.mkEnableOption "Firefox";

    vlc = lib.mkEnableOption "VLC";

    spotify = lib.mkEnableOption "Spotify";

    # Note: manually run `flatpak override --user --socket=wayland com.slack.Slack` for wayland support.
    slack = lib.mkEnableOption "Slack";

    telegram = lib.mkEnableOption "Telegram";

    discord = lib.mkEnableOption "Discord";

    obs = lib.mkEnableOption "OBS";

    audacity = lib.mkEnableOption "Audacity";

    gimp = lib.mkEnableOption "GIMP";

    calibre = lib.mkEnableOption "Calibre";

    zotero = lib.mkEnableOption "Zotero";

    obsidian = lib.mkEnableOption "Obsidian";
  };

  config = let
    addFlathub = option: appId:
      if option
      then {
        inherit appId;
        origin = "flathub";
      }
      else null;
  in {
    services.flatpak = {
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
      packages = pkgs.libExt.filterNull [
        (addFlathub config.nixconf.flatpak.brave "com.brave.Browser")
        (addFlathub config.nixconf.flatpak.chrome "com.google.Chrome")
        (addFlathub config.nixconf.flatpak.firefox "org.mozilla.firefox")
        (addFlathub config.nixconf.flatpak.vlc "org.videolan.VLC")
        (addFlathub config.nixconf.flatpak.spotify "com.spotify.Client")
        (addFlathub config.nixconf.flatpak.slack "com.slack.Slack")
        (addFlathub config.nixconf.flatpak.telegram "org.telegram.desktop")
        (addFlathub config.nixconf.flatpak.discord "com.discordapp.Discord")
        (addFlathub config.nixconf.flatpak.audacity "org.audacityteam.Audacity")
        (addFlathub config.nixconf.flatpak.obs "com.obsproject.Studio")
        (addFlathub config.nixconf.flatpak.gimp "org.gimp.GIMP")
        (addFlathub config.nixconf.flatpak.calibre "com.calibre_ebook.calibre")
        (addFlathub config.nixconf.flatpak.zotero "org.zotero.Zotero")
        (addFlathub config.nixconf.flatpak.obsidian "md.obsidian.Obsidian")
      ];
    };
  };
}
