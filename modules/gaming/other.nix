{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.gaming.other = {
    minecraft = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable minecraft";
    };

    minecraft-server = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable minecraft-server";
    };
  };

  config = {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = builtins.filter (p: p != null) [
        (
          if config.nixconf.gaming.other.minecraft
          then pkgs.prismlauncher
          else null
        )

        (
          if config.nixconf.gaming.other.minecraft-server
          then pkgs.minecraft-server
          else null
        )
      ];
    };
  };
}
