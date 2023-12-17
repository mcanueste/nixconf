{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.term;

  shellAliases = {
    ld = "lazydocker";
  };
in {
  options.nixhome.term = {
    lazydocker = mkBoolOption {description = "Enable lazydocker";};
  };

  config = lib.mkIf cfg.lazydocker {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};

    home.packages = [
      pkgs.lazydocker
    ];
  };
}
