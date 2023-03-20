{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.editors;
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
  options.nixhome.editors = {
    zotero = mkBoolOption "Enable zotero";
    datagrip = mkBoolOption "Enable JetBrains Datagrip";
    pycharm = mkBoolOption "Enable JetBrains PyCharm Professional";
  };

  config = {
    home.packages = filterPkgs [
      (getPkgIf cfg.zotero pkgs.zotero)
      (getPkgIf cfg.datagrip pkgs.jetbrains.datagrip)
      (getPkgIf cfg.pycharm pkgs.jetbrains.pycharm-professional)
    ];
  };
}
