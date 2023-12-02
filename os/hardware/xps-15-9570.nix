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
        kernelModules = [];
      };
      kernelModules = ["kvm-intel"];
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

    # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

    # intel gpu video acceleration setup
    # https://nixos.wiki/wiki/Accelerated_Video_Playback
    # nixpkgs.config.packageOverrides = pkg: {
    #   vaapiIntel = pkg.vaapiIntel.override {enableHybridCodec = true;};
    # };
    # See flake.nix for this override
    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}
