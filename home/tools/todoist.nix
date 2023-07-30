{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools;
  shellAliases = {
    t = "todoist";
  };
in {
  options.nixhome.tools = {
    todoist = mkBoolOption {description = "Enable todoist";};
  };

  config = lib.mkIf cfg.git {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};
    home.packages = [
      pkgs.todoist
    ];
  };
}
