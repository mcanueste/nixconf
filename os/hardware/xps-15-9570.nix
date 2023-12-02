{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixos.hardware.xps15;
in {
  options.nixos.hardware.xps15 = {
    enable = mkBoolOption {description = "Enable XPS15 hardware configuration";};

    swap = mkBoolOption {
      default = false;
      description = "Enable swap";
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems = {
      "/boot/efi" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
      };
      "/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };
    };

    swapDevices =
      if cfg.swap
      then [{device = "/dev/disk/by-label/swap";}]
      else [];

    boot = {
      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "ahci"
          "nvme"
          "usb_storage"
          "usbhid"
          "sd_mod"
          "rtsx_pci_sdmmc"
        ];
        kernelModules = ["i915"];
      };
      kernelModules = [
        "kvm-intel"
        "acpi_call"
        "acpi_rev_override"
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
      ];
      extraModulePackages = with config.boot.kernelPackages; [acpi_call];
      loader = {
        systemd-boot.enable = true;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot/efi";
        };
      };
    };

    hardware = {
      enableRedistributableFirmware = true;
      cpu.intel.updateMicrocode = true;

      # intel gpu video acceleration setup
      # https://nixos.wiki/wiki/Accelerated_Video_Playback
      # nixpkgs.config.packageOverrides = pkg: {
      #   vaapiIntel = pkg.vaapiIntel.override {enableHybridCodec = true;};
      # };
      # See flake.nix for this override
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver # LIBVA_DRIVER_NAME=iHD
          vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium) # replace with intel-vaapi-driver if necessary
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    };

    # Set VDPAU driver for intel gpu
    environment.variables = {
      VDPAU_DRIVER = "va_gl";
    };

    powerManagement.cpuFreqGovernor = "ondemand";

    services = {
      # This will save you money and possibly your life!
      thermald.enable = true;

      # For ssd life
      fstrim.enable = true;

      # Hard disk protection if the laptop falls:
      hdapsd.enable = true;

      # Enable touchpad etc.
      xserver.libinput.enable = true;

      # Enable power-profiles-daemon for switching power profiles
      power-profiles-daemon.enable = true;
    };

    # Gnome 40 introduced a new way of managing power, without tlp.
    # However, these 2 services clash when enabled simultaneously.
    # https://github.com/NixOS/nixos-hardware/issues/260
    # services.tlp.enable =
    #   lib.mkDefault ((lib.versionOlder (lib.versions.majorMinor lib.version) "21.05")
    #     || !config.services.power-profiles-daemon.enable);

    # set gpu drivers
    # services.xserver.videoDrivers = lib.mkDefault ["nvidia"];

    # hardware.nvidia.prime = {
    #   offload = {
    #     enable = lib.mkOverride 990 true;
    #     enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true; # Provides `nvidia-offload` command.
    #   };
    #   # Hardware should specify the bus ID for intel/nvidia devices
    # };

    # Load nvidia driver for Xorg and Wayland
    # services.xserver.videoDrivers = ["nvidia"];
    #
    # hardware.nvidia = {
    #   # Modesetting is required.
    #   modesetting.enable = true;
    #
    #   # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    #   powerManagement.enable = false;
    #   # Fine-grained power management. Turns off GPU when not in use.
    #   # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    #   powerManagement.finegrained = false;
    #
    #   # Use the NVidia open source kernel module (not to be confused with the
    #   # independent third-party "nouveau" open source driver).
    #   # Support is limited to the Turing and later architectures. Full list of
    #   # supported GPUs is at:
    #   # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    #   # Only available from driver 515.43.04+
    #   # Currently alpha-quality/buggy, so false is currently the recommended setting.
    #   open = false;
    #
    #   # Enable the Nvidia settings menu,
    #   # accessible via `nvidia-settings`.
    #   nvidiaSettings = true;
    #
    #   # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #   package = config.boot.kernelPackages.nvidiaPackages.stable;
    # };
  };
}
