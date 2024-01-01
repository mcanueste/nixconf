{
  lib,
  config,
  ...
}: {
  options.nixconf = {
    sound = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable pipewire";
    };
  };

  config = lib.mkIf config.nixconf.sound {
    # Sound cfg (pipewire)
    # Remove sound.enable or set it to false as it is only meant for ALSA-based configurations
    sound.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false; # for jack applications
    };
  };
}
