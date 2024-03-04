{
  lib,
  config,
  ...
}: {
  options.nixconf.hardware.boot = {
    swap = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable swap";
    };
  };

  config = {
    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-partlabel/BOOT";
        fsType = "vfat";
      };
      "/" = {
        device = "/dev/disk/by-label/root";
        fsType = "ext4";
      };
    };

    swapDevices =
      if config.nixconf.hardware.boot.swap
      then [{device = "/dev/disk/by-label/swap";}]
      else [];

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi = {
          canTouchEfiVariables = true;
        };
      };
      initrd = {
        luks.devices = {
          crypted = {
            device = "/dev/disk/by-partlabel/LUKS";
            preLVM = true;
            allowDiscards = true;
          };
        };
        availableKernelModules = [
          "xhci_pci" # USB 1,2, and 3 support
          "ahci" # SATA Device support
          "nvme" # NVME Device support
          "vmd"
          "thunderbolt"
          "sd_mod" # SCSI Disk support
          "usb_storage" # USB Storage support
          "usbhid" # USB Human Interface Device support, i.e. mouse, keyboard...
          "rtsx_pci_sdmmc" # Realtek SD/MMC Card support
        ];
        kernelModules = [
          "i915" # For Intel GPU
        ];
      };
      kernelModules = [
        "kvm-intel" # Virtualization support
        "acpi_call" # Allow ACPI calls, power management.
        "acpi_rev_override" # Might not be needed anymore, see below
        # https://github.com/Bumblebee-Project/bbswitch/issues/148
        "i915.enable_fbc=1" # Frame Buffer Compression for iGPU power saving.
        "i915.enable_psr=1" # Panel Self Refresh for iGPU power saving. Disable (0) if there are flickers.
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

    # --- Power setup
    powerManagement.cpuFreqGovernor = "ondemand";

    services = {
      # This will save you money and possibly your life!
      thermald.enable = true;

      # Enable power-profiles-daemon for switching power profiles
      power-profiles-daemon.enable = true;
    };
  };
}
