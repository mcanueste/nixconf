{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.desktop = {
    cosmic = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Cosmic desktop environment";
    };
  };

  config = lib.mkIf (config.nixconf.desktop.enable && config.nixconf.desktop.cosmic) {
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;
  };
}
