{
  lib,
  config,
  ...
}: {
  options.nixconf.hardware = {
    sound = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable pipewire";
    };
  };

  config = lib.mkIf config.nixconf.hardware.sound {
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
