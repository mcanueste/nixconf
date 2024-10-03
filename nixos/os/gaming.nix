{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.gaming = {
    # Check on proton db to see if game runs fine
    # https://www.protondb.com/

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gaming configuration";
    };

    steam = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable steam";
    };

    proton = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable proton";
    };

    prismlauncher = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable prismlauncher";
    };

    lutris = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable lutris launcher";
    };

    heroic = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable heroic launcher";
    };

    bottles = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable bottles";
    };
  };

  config = lib.mkIf config.nixconf.gaming.enable {
    programs.steam = {
      enable = config.nixconf.gaming.steam;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server

      # gamecope %command%
      # Start games in an optimized micro-compositor (good for resolution fixes)
      gamescopeSession.enable = true;
    };

    # gamemoderun %command%
    # temporary optimization for better performance
    programs.gamemode.enable = true;

    # mangohud %command%
    environment.systemPackages = builtins.filter (p: p != null) [
      pkgs.mangohud # for monitoring GPU/CPU usage, FPS, etc.

      (
        if config.nixconf.gaming.proton
        then pkgs.protonup
        else null
      )

      (
        if config.nixconf.gaming.prismlauncher
        then pkgs.prismlauncher
        else null
      )

      (
        if config.nixconf.gaming.lutris
        then pkgs.lutris
        else null
      )

      (
        if config.nixconf.gaming.heroic
        then pkgs.heroic
        else null
      )

      (
        if config.nixconf.gaming.bottles
        then pkgs.bottles
        else null
      )
    ];

    environment.sessionVariables = lib.mkIf config.nixconf.gaming.proton {
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/${config.nixconf.user}/.steam/root/compatibilitytools.d";
    };
  };
}
