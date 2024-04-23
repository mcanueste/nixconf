{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.service.sound = {
    pipewire = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable pipewire";
    };
  };

  config = {
    # Set sound.enable to false if pipewire, as it is only meant for ALSA-based configurations
    sound.enable = lib.mkForce (!config.nixconf.system.service.sound.pipewire);
    hardware.pulseaudio.enable = lib.mkForce (!config.nixconf.system.service.sound.pipewire);

    services.pipewire = {
      enable = config.nixconf.system.service.sound.pipewire;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
          bluez_monitor.properties = {
          	["bluez5.enable-sbc-xq"] = true,
          	["bluez5.enable-msbc"] = true,
          	["bluez5.enable-hw-volume"] = true,
          	["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
          }
        '')
      ];
    };
  };
}
