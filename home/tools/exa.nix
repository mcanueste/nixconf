{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools.exa;
in {
  options.nixhome.tools.exa = {
    enable = mkBoolOption {description = "Enable exa";};
  };

  config = lib.mkIf cfg.enable {
    programs.exa = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
  };
}
