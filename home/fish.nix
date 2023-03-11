{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.fish;
  mkBoolOption = description:
    lib.mkOption {
      inherit description;
      type = lib.types.bool;
      default = true;
    };
in {
  options.nixhome.fish = {
    enable = mkBoolOption "Enable fish config";
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
