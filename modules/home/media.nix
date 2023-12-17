{
  pkgs,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.media;
in {
  options.nixhome.media = {
    spotify = mkBoolOption {description = "Enable spotify";};
    zotero = mkBoolOption {description = "Enable zotero";};
    calibre = mkBoolOption {description = "Enable calibre";};
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.spotify pkgs.spotify)
      (getPackageIf cfg.zotero pkgs.zotero)
      (getPackageIf cfg.calibre pkgs.calibre)
    ];
  };
}
