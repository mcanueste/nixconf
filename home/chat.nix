{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.chat;
  mkTrueOption = description:
    lib.mkOption {
      inherit description;
      type = lib.types.bool;
      default = true;
    };
  mkFalseOption = description:
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
  options.nixhome.chat = {
    telegram = mkTrueOption "Enable telegram desktop";
    teams = mkTrueOption "Enable teams";
    slack = mkFalseOption "Enable slack";
    discord = mkTrueOption "Enable discord";
  };

  config = {
    home.packages = filterPkgs [
      (getPkgIf cfg.telegram pkgs.tdesktop)
      # (getPkgIf cfg.teams pkgs.teams)
      (getPkgIf cfg.slack pkgs.slack)
      (getPkgIf cfg.discord pkgs.discord)
    ];
  };
}
