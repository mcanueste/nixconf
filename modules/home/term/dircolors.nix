{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.term;
in {
  options.nixhome.term = {
    dircolors = mkBoolOption {description = "Enable dircolors";};
  };

  config = lib.mkIf cfg.dircolors {
    programs.dircolors = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = cfg.fish;
    };
  };
}
