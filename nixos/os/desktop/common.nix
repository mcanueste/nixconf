{
  lib,
  config,
  ...
}: {
  options.nixconf.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop configs.";
    };
  };

  config = lib.mkIf config.nixconf.desktop.enable {
    programs.dconf.enable = true;
    xdg.portal.enable = true;
  };
}
