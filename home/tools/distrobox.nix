{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools;

  shellAliases = {
    db = "distrobox";
  };
in {
  options.nixhome.tools = {
    distrobox = mkBoolOption {description = "Enable distrobox";};
  };

  config = lib.mkIf cfg.distrobox {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};
    home.packages = [
      pkgs.distrobox
    ];
  };
}
