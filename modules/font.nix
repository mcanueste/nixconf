{
  pkgs,
  config,
  lib,
  ...
}: {
  options.nixconf.font = {
    fonts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["JetBrainsMono"];
      description = "Font to install";
    };
    mainFont = lib.mkOption {
      type = lib.types.str;
      default = "JetBrainsMono";
      description = "Main font to use with other configs.";
    };
  };

  config = {
    home-manager.users.${config.nixconf.user} = {
      fonts.fontconfig.enable = true;
      home.packages = [
        (pkgs.nerdfonts.override {
          fonts = config.nixconf.font.fonts;
        })
      ];
    };
  };
}
