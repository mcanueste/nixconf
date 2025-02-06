{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.filesystem = {
    boot = lib.mkOption {
      type = lib.types.str;
      default = "/dev/disk/by-partlabel/BOOT";
      description = "Boot partition";
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

    luks = lib.mkOption {
      type = lib.types.str;
      default = "/dev/disk/by-partlabel/LUKS";
      description = "LUKS encrypted partition";
    };

    encrypted = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enabled disk decryption if the system is LUKS encrypted";
    };

    ssd = pkgs.libExt.mkEnabledOption "SSD Optimizations";
    hdd = lib.mkEnableOption "HDD Optimizations";
    automount = pkgs.libExt.mkEnabledOption "Automount Related Services";

    dbus = pkgs.libExt.mkEnabledOption "D-Bus";
    tumbler = pkgs.libExt.mkEnabledOption "Tumbler";
  };

  config = {
    fileSystems = {
      "/boot" = {
        device = config.nixconf.filesystem.boot;
        fsType = "vfat";
      };
      "/" = {
        device = config.nixconf.filesystem.root;
        fsType = "ext4";
      };
    };

    swapDevices = [
      {
        device = config.nixconf.filesystem.swap;
      }
    ];

    boot = lib.mkIf config.nixconf.filesystem.encrypted {
      initrd = {
        luks.devices = {
          crypted = {
            device = config.nixconf.filesystem.luks;
            preLVM = true;
            allowDiscards = true;
          };
        };
      };
    };

    services = {
      # For ssd life discard unused blocks
      fstrim.enable = config.nixconf.filesystem.ssd;

      # Hard disk protection if the laptop falls:
      hdapsd.enable = config.nixconf.filesystem.hdd;

      # Mount MTP devices (iPhone, Android, etc.)
      # Seamlessly access files and folders on remote resources.
      # Necessarry for file managers, mounts, trash, etc.
      gvfs.enable = config.nixconf.filesystem.automount;

      # In case gvfs doesn't work, enable udisk2 as well
      udisks2.enable = config.nixconf.filesystem.automount;

      # For interprocess communication
      dbus.enable = config.nixconf.filesystem.dbus;

      # Service for applications to request thumbnails for various URI schemes and Mime types
      tumbler.enable = config.nixconf.filesystem.tumbler;
    };
  };
}
