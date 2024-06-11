{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system = {
    # needed for work
    intune = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable MS Intune.";
    };
  };

  config = lib.mkIf config.nixconf.system.desktop.enable {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages = builtins.filter (p: p != null) [
        (
          if config.nixconf.system.intune
          then pkgs.intune-portal
          else null
        )
      ];
    };
  };
}
