{
  lib,
  config,
  ...
}: {
  options.nixconf.system.hardware.boot = {
    intelMicrocode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Intel microcode updates.";
    };

    cpuFreqGovernor = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "ondemand";
      description = ''
        Configure the governor used to regulate the frequency of the
        available CPUs. By default, the kernel configures the
        performance governor, although this may be overwritten in your
        hardware-configuration.nix file.

        Often used values: "ondemand", "powersave", "performance"
      '';
    };
  };

  config = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi = {
          canTouchEfiVariables = true;
        };
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

      initrd = {
        kernelModules = [
          "i915" # For Intel GPU
        ];
        availableKernelModules = [
          "ahci" # SATA Device support
          "nvme" # NVME Device support
          "sd_mod" # SCSI Disk support
          "usb_storage" # USB Storage support
          "rtsx_pci_sdmmc" # Realtek SD/MMC Card support
          "usbhid" # USB Human Interface Device support, i.e. mouse, keyboard...
          "xhci_pci" # USB 1,2, and 3 support
          "thunderbolt" # Thunderbolt support
          "vmd" # Intel Volume Management Device Driver
        ];
      };
    };

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = config.nixconf.system.hardware.boot.intelMicrocode;
    powerManagement.cpuFreqGovernor = config.nixconf.system.hardware.boot.cpuFreqGovernor;
  };
}
