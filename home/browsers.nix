{
  pkgs,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.browsers;
in {
  options.nixhome.browsers = {
    # TODO: move brave installation to home-manager for managing extensions
    brave = mkBoolOption {description = "Enable brave browser";};
    firefox = mkBoolOption {description = "Enable firefox browser";};
    chrome = mkBoolOption {description = "Enable chrome browser";};
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.brave pkgs.brave)
      (getPackageIf cfg.firefox pkgs.firefox)
      (getPackageIf cfg.chrome pkgs.google-chrome)
    ];
  };
}
