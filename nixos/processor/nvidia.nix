{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.nvidia = {
    enable = pkgs.libExt.mkEnabledOption "Nvidia GPU Configuration";

    isTuring = pkgs.libExt.mkEnabledOption "Turing Architecture Specific Configuration";

    sync = lib.mkEnableOption "Nvidia Optimus Sync Configuration";
  };

  config = lib.mkIf config.nixconf.nvidia.enable {
    # Add VDPAU driver for Nvidia GPU
    hardware.graphics = {
      extraPackages = with pkgs; [
        libvdpau-va-gl
        vaapiVdpau
      ];
    };

    # Set VDPAU driver for Nvidia gpu
    environment.variables = {
      VDPAU_DRIVER = "va_gl";
    };

    # NVIDIA Optimus Prime setup
    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # enable the open source drivers if the package supports it
      open = lib.mkOverride 990 (config.hardware.nvidia.package ? open && config.hardware.nvidia.package ? firmware);

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      package = config.boot.kernelPackages.nvidiaPackages.production;

      # Optimus PRIME config for offloading
      prime = {
        sync.enable = config.nixconf.nvidia.sync;
        offload = {
          enable = !config.nixconf.nvidia.sync;
          enableOffloadCmd = !config.nixconf.nvidia.sync;
        };

        # Make sure to use the correct Bus ID values for your system!
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = config.nixconf.nvidia.isTuring && !config.nixconf.nvidia.sync;
    };

    # Enable GPU drivers
    services.xserver.videoDrivers = ["nvidia"];
    boot.blacklistedKernelModules = ["nouveau" "bbswitch"];
  };
}
