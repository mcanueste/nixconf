{
  pkgs,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.browsers;
in {
  options.nixhome.browsers = {
    brave = mkBoolOption {description = "Enable brave browser";};
    firefox = mkBoolOption {
      description = "Enable firefox browser";
      default = false;
    };
    chrome = mkBoolOption {
      description = "Enable chrome browser";
      default = false;
    };
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.brave pkgs.brave)
      (getPackageIf cfg.firefox pkgs.firefox)
      (getPackageIf cfg.chrome pkgs.google-chrome)
    ];
  };
}
