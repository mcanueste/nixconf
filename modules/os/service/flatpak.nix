{
  lib,
  config,
  ...
}: {
  options.nixconf.system.service.flatpak = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable flatpaks";
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
      description = "Enable slack";
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

  config = lib.mkIf config.nixconf.system.service.flatpak.enable {
    environment.sessionVariables.XDG_DATA_DIRS = lib.mkOverride 1000 (lib.strings.concatStringsSep ":" [
      config.environment.sessionVariables.XDG_DATA_DIRS
      "/var/lib/flatpak/exports/share"
      "$HOME/.local/share/flatpak/exports/share"
    ]);

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
        (addFlathub config.nixconf.system.service.flatpak.vlc "org.videolan.VLC")
        (addFlathub config.nixconf.system.service.flatpak.spotify "com.spotify.Client")
        (addFlathub config.nixconf.system.service.flatpak.slack "com.slack.Slack")
        (addFlathub config.nixconf.system.service.flatpak.telegram "org.telegram.desktop")
        (addFlathub config.nixconf.system.service.flatpak.discord "com.discordapp.Discord")
        (addFlathub config.nixconf.system.service.flatpak.audacity "org.audacityteam.Audacity")
        (addFlathub config.nixconf.system.service.flatpak.obs "com.obsproject.Studio")
        (addFlathub config.nixconf.system.service.flatpak.gimp "org.gimp.GIMP")
        (addFlathub config.nixconf.system.service.flatpak.calibre "com.calibre_ebook.calibre")
        (addFlathub config.nixconf.system.service.flatpak.zotero "org.zotero.Zotero")
        (addFlathub config.nixconf.system.service.flatpak.obsidian "md.obsidian.Obsidian")
      ];
    };
  };
}
