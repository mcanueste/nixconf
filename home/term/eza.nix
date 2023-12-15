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
    eza = mkBoolOption {description = "Enable eza";};
  };

  config = lib.mkIf cfg.eza {
    programs.eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
  };
}
