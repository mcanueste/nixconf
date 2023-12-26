{
  pkgs,
  lib,
  config,
  ...
}: {
  # This sets up hardware specific configuration for XPS15 9560-9570
  # - Boot/fs setup
  # - Kernel parameters
  # - Power management
  # - Touchpad and other aux devices
  # - SSD specific settings
  # - Bluetooth
  # - Intel/Nvidia Prime setup

  options.nixconf.hardware.xps15 = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable XPS15 hardware configuration";
    };

    swap = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable swap";
    };
  };

  config = lib.mkIf config.nixconf.hardware.xps15.enable {
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
      if config.nixconf.hardware.xps15.swap
      then [{device = "/dev/disk/by-label/swap";}]
      else [];

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot/efi";
        };
      };
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
    };

    hardware = {
      enableRedistributableFirmware = true;
      cpu.intel.updateMicrocode = true;
    };

    services = {
      # For ssd life
      fstrim.enable = true;

      # Hard disk protection if the laptop falls:
      hdapsd.enable = true;

      # Enable touchpad support
      xserver.libinput.enable = true;
    };

    # enable britghtness control
    programs.light.enable = true;

    # ------------------------ Power setup
    powerManagement.cpuFreqGovernor = "ondemand";

    services = {
      # This will save you money and possibly your life!
      thermald.enable = true;

      # Enable power-profiles-daemon for switching power profiles
      power-profiles-daemon.enable = true;
    };

    # ------------------------ GPU setup

    # intel gpu video acceleration setup
    # https://nixos.wiki/wiki/Accelerated_Video_Playback
    # nixpkgs.config.packageOverrides = pkg: {
    #   vaapiIntel = pkg.vaapiIntel.override {enableHybridCodec = true;};
    # };
    # See flake.nix for this override
    hardware.opengl = {
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

    # NVIDIA Optimus Prime setup
    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # Optimus PRIME config for offloading
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # Make sure to use the correct Bus ID values for your system!
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # Set VDPAU driver for intel gpu
    environment.variables = {
      VDPAU_DRIVER = "va_gl";
    };

    # Enable GPU drivers
    services.xserver.videoDrivers = ["intel" "nvidia"];
    boot.blacklistedKernelModules = ["nouveau" "bbswitch"];

    # Bluetooth setup
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    # Wireplumber config for sound codecs with bluetooth headphones
    environment.etc = {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
        	["bluez5.enable-sbc-xq"] = true,
        	["bluez5.enable-msbc"] = true,
        	["bluez5.enable-hw-volume"] = true,
        	["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    };
  };
}
