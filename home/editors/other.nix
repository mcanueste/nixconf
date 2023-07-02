{
  pkgs,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.editors;
in {
  options.nixhome.editors = {
    obsidian = mkBoolOption {description = "Enable Obsidian";};
    datagrip = mkBoolOption {
      description = "Enable JetBrains Datagrip";
      default = false;
    };
    pycharm = mkBoolOption {
      description = "Enable JetBrains PyCharm Professional";
      default = false;
    };
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.obsidian pkgs.obsidian)
      (getPackageIf cfg.datagrip pkgs.jetbrains.datagrip)
      (getPackageIf cfg.pycharm pkgs.jetbrains.pycharm-professional)
    ];
  };
}