{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.fish;
in {
  options.nixhome.fish = {
    enable = mkBoolOption {description = "Enable fish config";};
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
    };

    programs.dircolors = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
