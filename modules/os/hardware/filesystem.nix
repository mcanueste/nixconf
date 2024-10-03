{
  lib,
  config,
  ...
}: {
  options.nixconf.os.hardware.filesystem = {
    boot = lib.mkOption {
      type = lib.types.str;
      default = "/dev/disk/by-partlabel/BOOT";
      description = "Boot partition";
    };

    luks = lib.mkOption {
      type = lib.types.str;
      default = "/dev/disk/by-partlabel/LUKS";
      description = "LUKS encrypted partition";
    };

    root = lib.mkOption {
      type = lib.types.str;
      default = "/dev/disk/by-label/root";
      description = "Root partition";
    };

    swap = lib.mkOption {
      type = lib.types.str;
      default = "/dev/disk/by-label/swap";
      description = "Swap partition";
    };
  };

  config = {
    fileSystems = {
      "/boot" = {
        device = config.nixconf.os.hardware.filesystem.boot;
        fsType = "vfat";
      };
      "/" = {
        device = config.nixconf.os.hardware.filesystem.root;
        fsType = "ext4";
      };
    };

    swapDevices = [
      {
        device = config.nixconf.os.hardware.filesystem.swap;
      }
    ];

    boot = {
      initrd = {
        luks.devices = {
          crypted = {
            device = config.nixconf.os.hardware.filesystem.luks;
            preLVM = true;
            allowDiscards = true;
          };
        };
      };
    };
  };
}
