{
  pkgs,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.gui-tools;
in {
  options.nixhome.gui-tools = {
    zotero = mkBoolOption {description = "Enable zotero";};
    calibre = mkBoolOption {description = "Enable calibre";};
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.zotero pkgs.zotero)
      (getPackageIf cfg.calibre pkgs.calibre)
    ];
  };
}
