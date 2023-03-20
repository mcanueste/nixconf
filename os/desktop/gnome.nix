{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixos.desktop.gnome;
in {
  options.nixos.desktop.gnome = {
    enable = lib.mkOption {
      default = false;
      description = "Enable gnome desktop";
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

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # enable dconf
    programs.dconf.enable = true;

    # Packages
    environment.systemPackages = with pkgs; [
      gnome3.gnome-tweaks
    ];

    # services.xserver.videoDrivers = [ "nvidia" ];
    # hardware.opengl.enable = true;
    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    # boot.blacklistedKernelModules = [ "nouveau" ];
    # boot.kernelParams = [ "module_blacklist=i915" ];
  };
}
