{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.hardware.nvidia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Nvidia GPU configuration";
    };

    isTuring = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Turing architecture specific configuration";
    };

    sync = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Nvidia Optimus Sync configuration";
    };
  };

  config = lib.mkIf config.nixconf.system.hardware.nvidia.enable {
    # intel gpu video acceleration setup
    # https://nixos.wiki/wiki/Accelerated_Video_Playback

    nixpkgs.config.packageOverrides = pkg: {
      vaapiIntel = pkg.vaapiIntel.override {enableHybridCodec = true;};
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium) # replace with intel-vaapi-driver if necessary
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    # NVIDIA Optimus Prime setup
    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      package = config.boot.kernelPackages.nvidiaPackages.production;

      # Optimus PRIME config for offloading
      prime = {
        sync.enable = config.nixconf.system.hardware.nvidia.sync;
        offload = {
          enable = !config.nixconf.system.hardware.nvidia.sync;
          enableOffloadCmd = !config.nixconf.system.hardware.nvidia.sync;
        };

        # Make sure to use the correct Bus ID values for your system!
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = config.nixconf.system.hardware.nvidia.isTuring && !config.nixconf.system.hardware.nvidia.sync;
    };

    # Set VDPAU driver for intel gpu
    environment.variables = {
      VDPAU_DRIVER = "va_gl";
    };

    # Enable GPU drivers
    services.xserver.videoDrivers = ["intel" "nvidia"];
    boot.blacklistedKernelModules = ["nouveau" "bbswitch"];

    # Enable nvidia offload script
    environment.systemPackages = builtins.filter (p: p != null) [
      (
        if config.nixconf.system.hardware.nvidia.enable && !config.nixconf.system.hardware.nvidia.sync
        then
          pkgs.writeShellApplication {
            name = "nvidia-offload";
            runtimeInputs = [];
            text = ''
              #!/usr/bin/env bash
              export __NV_PRIME_RENDER_OFFLOAD=1
              export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
              export __GLX_VENDOR_LIBRARY_NAME=nvidia
              export __VK_LAYER_NV_optimus=NVIDIA_only
              exec "$@"
            '';
          }
        else null
      )
    ];
  };
}
