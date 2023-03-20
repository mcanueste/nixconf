{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixos.desktop.qtile;
in {
  options.nixos.desktop.qtile = {
    enable = lib.mkOption {
      default = true;
      description = "Enable i3";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;
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
      displayManager.defaultSession = "xfce+qtile";
      windowManager.qtile.enable = true;
    };

    environment.systemPackages = with pkgs; [
      libinput
      libxkbcommon
      # pulseaudio
      # wayland
      # wlroots
      python310Packages.dbus-next
      python310Packages.qtile-extras
      rofi
    ];

    # services.xserver.videoDrivers = [ "nvidia" ];
    # hardware.opengl.enable = true;
    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    # boot.blacklistedKernelModules = [ "nouveau" ];
    # boot.kernelParams = [ "module_blacklist=i915" ];
  };
}
