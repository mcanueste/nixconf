{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools;

  shellAliases = {
    ld = "lazydocker";
  };
in {
  options.nixhome.tools = {
    lazydocker = mkBoolOption {description = "Enable lazydocker";};
  };

  config = lib.mkIf cfg.lazydocker {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};

    # TODO: install with home-manager module and check out settings
    home.packages = [
      pkgs.lazydocker
    ];
  };
}
