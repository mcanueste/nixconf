{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.desktop = {
    cosmic = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Cosmic desktop environment";
    };
  };

  config = lib.mkIf (config.nixconf.system.desktop.enable && config.nixconf.system.desktop.cosmic) {
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;

    # Additional Packages
    # environment.systemPackages = [
    # ];

    # Exclude Cosmic Packages
    # environment.cosmic.excludePackages = [
    # ];
  };
}
