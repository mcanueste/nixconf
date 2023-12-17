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
    fish = mkBoolOption {description = "Enable fish config";};
  };

  config = lib.mkIf cfg.fish {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
    };
  };
}
