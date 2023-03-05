{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.desktop;
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
  filterPkgs = packages: builtins.filter (p: ! isNull p) packages;
in {
  options.nixhome.desktop = {
    enable = mkBoolOption "Enable desktop programs/configs";
    packages.brave = mkBoolOption "Enable brave browser";
    packages.teams = mkBoolOption "Enable teams";
    packages.datagrip = mkBoolOption "Enable JetBrains Datagrip";
    packages.pycharm = mkBoolOption "Enable JetBrains PyCharm Professional";
    packages.obsidian = mkBoolOption "Enable Obsidian Markdown Editor";
    packages.nerdfonts = mkBoolOption "Enable Nerd Fonts";
  };

  config = lib.mkIf cfg.enable {
    home.packages = filterPkgs [
      (getPkgIf cfg.packages.brave pkgs.brave)
      (getPkgIf cfg.packages.teams pkgs.teams)
      (getPkgIf cfg.packages.datagrip pkgs.jetbrains.datagrip)
      (getPkgIf cfg.packages.pycharm pkgs.jetbrains.pycharm-professional)
      (getPkgIf cfg.packages.obsidian pkgs.obsidian)
      (
        getPkgIf cfg.packages.nerdfonts
        (pkgs.nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
      )
    ];
    fonts.fontconfig.enable = cfg.packages.nerdfonts;
  };
}
