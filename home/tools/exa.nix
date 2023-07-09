{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools;
in {
  options.nixhome.tools = {
    exa = mkBoolOption {description = "Enable exa";};
  };

  config = lib.mkIf cfg.exa {
    programs.exa = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
  };
}
