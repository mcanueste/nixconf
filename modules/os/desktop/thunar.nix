{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.desktop = {
    thunar = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable thunar manager";
    };
  };

  config = lib.mkIf config.nixconf.desktop.thunar {
    # Tumbler is a D-Bus service for applications to request thumbnails
    # for various URI schemes and MIME types.
    services.tumbler.enable = true;

    # Enable thunar file manager and other services for automated mounts etc.
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}
