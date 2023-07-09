{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools;
  termCfg = config.nixhome.term;
in {
  options.nixhome.tools = {
    zoxide = mkBoolOption {description = "Enable zoxide";};
  };

  config = lib.mkIf cfg.zoxide {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = termCfg.fish;
    };
  };
}
