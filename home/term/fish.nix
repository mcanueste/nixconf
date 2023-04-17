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
