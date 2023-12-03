{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixos.hardware;
in {
  options.nixos.hardware.bluetooth = mkBoolOption {description = "Enable Bluetooth configuration";};

  config = lib.mkIf cfg.bluetooth {
    # ------ Bluetooth setup
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    services.blueman.enable = true;
    # Wireplumber config for sound codecs
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
