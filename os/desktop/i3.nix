{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixos.desktop.i3;
in {
  options.nixos.desktop.i3 = {
    enable = mkBoolOption {description = "Enable i3 window manager";};
  };

  config = lib.mkIf cfg.enable {
    # links /libexec from derivations to /run/current-system/sw
    environment.pathsToLink = ["/libexec"];
    services.xserver = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };
  };
}
