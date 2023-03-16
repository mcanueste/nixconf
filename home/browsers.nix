{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.browsers;
  mkBoolOption = description:
    lib.mkOption {
      inherit description;
      type = lib.types.bool;
      default = true;
    };
  getPkgIf = cond: pkg:
    if cond
    then pkg
    else null;
  filterPkgs = builtins.filter (p: p != null);
in {
  options.nixhome.browsers = {
    brave = mkBoolOption "Enable brave browser";
  };

  config = {
    home.packages = filterPkgs [
      (getPkgIf cfg.brave pkgs.brave)
    ];
  };
}