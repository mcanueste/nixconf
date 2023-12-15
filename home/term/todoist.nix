{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.term;
  shellAliases = {
    t = "todoist";
  };
in {
  options.nixhome.term = {
    todoist = mkBoolOption {description = "Enable todoist";};
  };

  config = lib.mkIf cfg.todoist {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};
    home.packages = [
      pkgs.todoist
    ];
  };
}
