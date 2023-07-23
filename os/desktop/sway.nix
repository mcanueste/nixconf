{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixos.desktop;
in {
  options.nixos.desktop = {
    sway = mkBoolOption {description = "Enable sway window manager";};
  };

  config = lib.mkIf cfg.sway {
    programs.dconf.enable = true;
    programs.sway.enable = true;
  };
}
