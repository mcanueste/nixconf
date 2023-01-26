{
pkgs,
lib,
config,
...
}: let
  cfg = config.nixconf.hardware.xps15;
in {
  options.nixconf.hardware.xps15 = {
    enable = lib.mkEnableOption {
      default = true;
      description = "Enable XPS15 hardware configuration";
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

    swapDevices = [ 
      {device = "/dev/disk/by-label/swap";} 
    ];

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
        kernelModules = [];
      };
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [];
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
    };

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  };
}
