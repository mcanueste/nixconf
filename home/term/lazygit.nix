{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.term;

  shellAliases = {
    lg = "lazygit";
  };
in {
  options.nixhome.term = {
    lazygit = mkBoolOption {description = "Enable lazygit";};
  };

  config = lib.mkIf cfg.lazygit {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};

    home.packages = [
      pkgs.lazygit
    ];
  };
}
