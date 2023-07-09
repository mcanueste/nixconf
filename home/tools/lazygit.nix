{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools.lazygit;

  shellAliases = {
    lg = "lazygit";
  };
in {
  options.nixhome.tools.lazygit = {
    enable = mkBoolOption {description = "Enable lazygit";};
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};

    # TODO: install with home-manager module and check out settings
    home.packages = [
      pkgs.lazygit
    ];
  };
}
