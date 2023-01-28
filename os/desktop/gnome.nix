{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixconf.desktop.gnome;
in {
  options.nixconf.desktop.gnome = {
    enable = lib.mkOption {
      default = true;
      description = "Enable gnome desktop";
      type = lib.types.bool;
    };

    keyboardLayout = lib.mkOption {
      default = "us";
      description = "Keyboard layout";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable touchpad support
    services.xserver.libinput.enable = true;

    # Configure keymap in X11
    services.xserver = {
      layout = cfg.keyboardLayout;
      xkbVariant = "";
    };

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # services.xserver.videoDrivers = [ "nvidia" ];
    # hardware.opengl.enable = true;
    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    # boot.blacklistedKernelModules = [ "nouveau" ];
    # boot.kernelParams = [ "module_blacklist=i915" ];
  };
}
