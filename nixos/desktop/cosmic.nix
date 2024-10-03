{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.desktop. cosmic = lib.mkEnableOption "Cosmic Desktop Environment";

  config = lib.mkIf (config.nixconf.desktop.enable && config.nixconf.desktop.cosmic) {
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;
  };
}
