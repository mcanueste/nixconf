{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools;

  shellAliases = {
    lg = "lazygit";
  };
in {
  options.nixhome.tools = {
    lazygit = mkBoolOption {description = "Enable lazygit";};
  };

  config = lib.mkIf cfg.lazygit {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};

    # TODO: install with home-manager module and check out settings
    home.packages = [
      pkgs.lazygit
    ];
  };
}
