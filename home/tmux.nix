{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.tmux;
  mkBoolOption = description:
    lib.mkOption {
      inherit description;
      type = lib.types.bool;
      default = true;
    };
in {
  options.nixhome.tmux = {
    enable = mkBoolOption "Enable tmux";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
    };
  };
}
