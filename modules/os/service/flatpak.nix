{
  lib,
  config,
  ...
}: {
  options.nixconf.os.service.flatpak = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable flatpaks";
    };

    chrome = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable chrome";
    };

    firefox = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable firefox";
    };

    vlc = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable vlc";
    };

    spotify = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable spotify";
    };

    slack = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable slack.
        Note: manually run `flatpak override --user --socket=wayland com.slack.Slack` for wayland support.
      '';
    };

    telegram = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable telegram";
    };

    discord = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable discord";
    };

    obs = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable OBS";
    };

    audacity = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable audacity";
    };

    gimp = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gimp";
    };

    calibre = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable calibre";
    };

    zotero = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable zotero";
    };

    obsidian = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable obsidian";
    };
  };

  config = lib.mkIf config.nixconf.os.service.flatpak.enable {
    services.flatpak = let
      addFlathub = option: appId:
        if option
        then {
          inherit appId;
          origin = "flathub";
        }
        else null;
    in {
      enable = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
      packages = builtins.filter (p: p != null) [
        (addFlathub config.nixconf.os.service.flatpak.chrome "com.google.Chrome")
        (addFlathub config.nixconf.os.service.flatpak.firefox "org.mozilla.firefox")
        (addFlathub config.nixconf.os.service.flatpak.vlc "org.videolan.VLC")
        (addFlathub config.nixconf.os.service.flatpak.spotify "com.spotify.Client")
        (addFlathub config.nixconf.os.service.flatpak.slack "com.slack.Slack")
        (addFlathub config.nixconf.os.service.flatpak.telegram "org.telegram.desktop")
        (addFlathub config.nixconf.os.service.flatpak.discord "com.discordapp.Discord")
        (addFlathub config.nixconf.os.service.flatpak.audacity "org.audacityteam.Audacity")
        (addFlathub config.nixconf.os.service.flatpak.obs "com.obsproject.Studio")
        (addFlathub config.nixconf.os.service.flatpak.gimp "org.gimp.GIMP")
        (addFlathub config.nixconf.os.service.flatpak.calibre "com.calibre_ebook.calibre")
        (addFlathub config.nixconf.os.service.flatpak.zotero "org.zotero.Zotero")
        (addFlathub config.nixconf.os.service.flatpak.obsidian "md.obsidian.Obsidian")
      ];
    };
  };
}
