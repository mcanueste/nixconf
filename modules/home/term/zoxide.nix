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
    zoxide = mkBoolOption {description = "Enable zoxide";};
  };

  config = lib.mkIf cfg.zoxide {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = cfg.fish;
    };
  };
}
