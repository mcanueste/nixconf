{
  pkgs,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.chat;
in {
  options.nixhome.chat = {
    telegram = mkBoolOption {description = "Enable telegram desktop";};
    slack = mkBoolOption {
      description = "Enable slack";
      default = false;
    };
    discord = mkBoolOption {description = "Enable discord";};
    teams = mkBoolOption {
      description = "Enable teams";
      default = false;
    };
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.telegram pkgs.tdesktop)
      (getPackageIf cfg.teams pkgs.teams)
      (getPackageIf cfg.slack pkgs.slack)
      (getPackageIf cfg.discord pkgs.discord)
    ];
  };
}
