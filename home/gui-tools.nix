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
    todoist = mkBoolOption {description = "Enable todoist desktop app";};
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.zotero pkgs.zotero)
      (getPackageIf cfg.todoist pkgs.todoist-electron)
    ];
  };
}
