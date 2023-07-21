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
    i3 = mkBoolOption {description = "Enable i3 window manager";};
  };

  config = lib.mkIf cfg.i3 {
    # links /libexec from derivations to /run/current-system/sw
    environment.pathsToLink = ["/libexec"];
    # environment.systemPackages = [pkgs.lxappearance];
    programs.dconf.enable = true;
    services.xserver = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };
  };
}
