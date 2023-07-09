{
  pkgs,
  lib,
  config,
  ...
}: with pkgs.lib.conflib; let
  cfg = config.nixhome.tools.lazygit;
in {
  options.nixhome.tools.lazygit = {
    enable = mkBoolOption { description = "Enable lazygit"; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.lazygit
    ];

    programs.bash = {
      shellAliases = {
        lg = "lazygit";
      };
    };

    programs.fish = {
      shellAliases = {
        lg = "lazygit";
      };
    };
  };
}
