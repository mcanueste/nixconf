{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.os.desktop = {
    cosmic = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Cosmic desktop environment";
    };
  };

  config = lib.mkIf (config.nixconf.os.desktop.enable && config.nixconf.os.desktop.cosmic) {
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
