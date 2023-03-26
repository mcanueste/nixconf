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
        extraPackages = with pkgs; [
          dmenu #application launcher most people use
          i3lock #default i3 screen locker
          i3blocks #if you are planning on using i3blocks over i3status
        ];
      };
    };
  };
}
