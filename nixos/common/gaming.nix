{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.gaming = {
    # Check on proton db to see if game runs fine
    # https://www.protondb.com/

    enable = lib.mkEnableOption "Gaming Configuration";

    steam = pkgs.libExt.mkEnabledOption "Steam";

    proton = pkgs.libExt.mkEnabledOption "Proton";

    prismlauncher = pkgs.libExt.mkEnabledOption "Prism Launcher";

    lutris = lib.mkEnableOption "Lutris Launcher";

    heroic = lib.mkEnableOption "Heroic Launcher";

    bottles = lib.mkEnableOption "Bottles";
  };

  config = lib.mkIf config.nixconf.gaming.enable {
    programs.steam = {
      enable = config.nixconf.gaming.steam;

      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = config.nixconf.gaming.steam;

      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = config.nixconf.gaming.steam;

      # gamecope %command%
      # Start games in an optimized micro-compositor (good for resolution fixes)
      gamescopeSession.enable = config.nixconf.gaming.steam;
    };

    # gamemoderun %command%
    # temporary optimization for better performance
    programs.gamemode.enable = true;

    environment.systemPackages = pkgs.libExt.filterNull [
      # for monitoring GPU/CPU usage, FPS, etc. - mangohud %command%
      pkgs.mangohud

      (pkgs.libExt.mkIfElseNull config.nixconf.gaming.proton pkgs.protonup)
      (pkgs.libExt.mkIfElseNull config.nixconf.gaming.prismlauncher pkgs.prismlauncher)
      (pkgs.libExt.mkIfElseNull config.nixconf.gaming.lutris pkgs.lutris)
      (pkgs.libExt.mkIfElseNull config.nixconf.gaming.heroic pkgs.heroic)
      (pkgs.libExt.mkIfElseNull config.nixconf.gaming.bottles pkgs.bottles)
    ];

    environment.sessionVariables = lib.mkIf config.nixconf.gaming.proton {
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/${config.nixconf.username}/.steam/root/compatibilitytools.d";
    };
  };
}
