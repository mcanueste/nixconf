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
      description = "Enable nerd fonts";
    };
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
}
