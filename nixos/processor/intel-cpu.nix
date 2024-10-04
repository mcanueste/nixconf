{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.boot = {
    intelMicrocode = pkgs.libExt.mkEnabledOption "Intel Microcode Updates";

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
      initrd = {
        # Stage 1 Boot Available Kernel Modules
        availableKernelModules = [
          "ahci" # SATA devices on modern AHCI controllers
          "nvme" # NVMe drives (really fast SSDs)
          "sd_mod" # SCSI, SATA, and PATA (IDE) devices
          "usb_storage" # Utilize USB Mass Storage (USB flash drives)
          "rtsx_pci_sdmmc" # Realtek SD/MMC Card support
          "usbhid" # USB Human Interface Device support, i.e. mouse, keyboard...
          "uas" # USB Attached SCSI support
          "xhci_pci" # USB 3 support (eXtensible Host Controller Interface)
          "ehci_pci" # USB 2 support (Enhanced Host Controller Interface)
          "sdhci_pci" # Secure Digital Host Controller Interface (SD cards)
          "rtsx_pci_sdmmc" # Realtek PCI-E SD/MMC Card Host Driver
          "thunderbolt" # Thunderbolt support
          "vmd" # Intel Volume Management Device Driver
        ];

        kernelModules = ["i915"]; # intel iGPU
      };

      # After root fs is mounted
      kernelModules = [
        "kvm-intel" # Virtualization support on Intel
        "coretemp" # Intel CPU temperature sensor
        "acpi_call" # Allow ACPI calls, power management.
        "acpi_rev_override" # Override ACPI revision
        "i915.enable_fbc=1" # Enable framebuffer compression for iGPU power savings
        "i915.enable_psr=1" # Panel Self Refresh for iGPU power savings. Disable (0) if there are flickers.
      ];

      extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    };

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = config.nixconf.boot.intelMicrocode;
    powerManagement.cpuFreqGovernor = config.nixconf.boot.cpuFreqGovernor;
  };
}
