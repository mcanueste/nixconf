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
    foliate = mkBoolOption {description = "Enable foliate epub reader";};
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.zotero pkgs.zotero)
      (getPackageIf cfg.foliate pkgs.foliate)
    ];
  };
}
