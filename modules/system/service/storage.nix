{
  lib,
  config,
  ...
}: {
  options.nixconf.system.service.storage = {
    trim = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable fstrim for better SSD health";
    };

    hdapsd = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hard-drive protection against drops for laptops";
    };
  };

  config = {
    services = {
      # For ssd life discard unused blocks
      fstrim.enable = config.nixconf.system.service.storage.trim;

      # Hard disk protection if the laptop falls:
      hdapsd.enable = config.nixconf.system.service.storage.hdapsd;
    };
  };
}
