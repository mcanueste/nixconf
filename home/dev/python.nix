{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.dev.python;
in {
  options.nixhome.dev.python = {
    enable = mkBoolOption {description = "Enable python";};
    poetry = mkBoolOption {description = "Enable poetry";};
  };

  config = lib.mkIf cfg.enable {
    home.packages = filterPackages [
      # pkgs.python310 -> installed also with neovim config. TODO: fix later
      (getPackageIf cfg.poetry pkgs.poetry)
    ];
  };
}
