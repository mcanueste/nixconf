{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixos.desktop.i3;
in {
  options.nixos.desktop.i3 = {
    enable = lib.mkOption {
      default = false;
      description = "Enable i3";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Configure keymap in X11
      layout = "us";
      xkbVariant = "";

      # Enable touchpad support
      libinput.enable = true;

      # Enable the xfce as desktop manager
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };

      # Enable i3
      displayManager.defaultSession = "xfce";
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          lxappearance
          dmenu
          i3-gaps
          i3status
          i3lock
          i3blocks
        ];
      };
    };
    programs.dconf.enable = true;

    # services.xserver.videoDrivers = [ "nvidia" ];
    # hardware.opengl.enable = true;
    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    # boot.blacklistedKernelModules = [ "nouveau" ];
    # boot.kernelParams = [ "module_blacklist=i915" ];
  };
}
