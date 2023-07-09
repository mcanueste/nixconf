{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools.direnv;
in {
  options.nixhome.tools.direnv = {
    enable = mkBoolOption {description = "Enable direnv";};
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      # no need for fish integration, integrated by default
    };
  };
}
