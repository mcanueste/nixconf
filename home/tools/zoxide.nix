{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools.zoxide;
  termCfg = config.nixhome.term;
in {
  options.nixhome.tools.zoxide = {
    enable = mkBoolOption {description = "Enable zoxide";};
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = termCfg.fish;
    };
  };
}
