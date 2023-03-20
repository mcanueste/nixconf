{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixos.desktop.awesome;
  # https://github.com/cufta22/dotfiles.git -> qtile catppuccin theme
  # https://github.com/V2BlockBuster2K/Awespuccin -> awesome catppuccin theme
in {
  options.nixos.desktop.awesome = {
    enable = lib.mkOption {
      default = false;
      description = "Enable awesome";
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
      desktopManager = {xterm.enable = false;};

      displayManager = {
        sddm.enable = true;
        defaultSession = "none+awesome";
      };

      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks # is the package manager for Lua modules
          luadbi-mysql # Database abstraction layer
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      libinput
      libxkbcommon
      rofi
    ];

    # services.xserver.videoDrivers = [ "nvidia" ];
    # hardware.opengl.enable = true;
    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    # boot.blacklistedKernelModules = [ "nouveau" ];
    # boot.kernelParams = [ "module_blacklist=i915" ];
  };
}
