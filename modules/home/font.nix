{
  pkgs,
  config,
  lib,
  ...
}: {
  options.nixconf.font = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fontconfig";
    };
    fonts = lib.mkOption {
      description = "Font to install";
      default = ["JetBrainsMono"];
      type = lib.types.listOf lib.types.str;
    };
  };

  config = lib.mkIf config.nixconf.font.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      (pkgs.nerdfonts.override {
        fonts = config.nixconf.font.fonts;
      })
    ];
  };
}
