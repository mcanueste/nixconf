{
  pkgs,
  config,
  lib,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.font;
in {
  options.nixhome.font = {
    enable = mkBoolOption {description = "Enable fontconfig";};
    font = lib.mkOption {
      description = "Font to install";
      default = "JetBrainsMono";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      (pkgs.nerdfonts.override {
        fonts = [ cfg.font ];
      })
    ];
  };
}
