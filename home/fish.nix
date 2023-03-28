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
      shellAliases = {
        ngc = "sudo nix-collect-garbage";
        nsw = "sudo nixos-rebuild switch --flake ~/nix/nixconf/";
      };
    };

    programs.dircolors = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
