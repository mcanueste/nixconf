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
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.brave pkgs.brave)
    ];
  };
}
