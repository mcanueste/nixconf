{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./kanata.nix
  ];

  options.nixconf.peripherals = {
    bluetooth = pkgs.libExt.mkEnabledOption "Bluetooth";
    logitech = pkgs.libExt.mkEnabledOption "Logitech";
  };

  config = {
    services.libinput.enable = true;

    # Enable hardware support for bluetooth
    hardware.bluetooth = {
      enable = config.nixconf.peripherals.bluetooth;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket"; # enable A2DP profile
          Experimental = true; # show battery charge status
        };
      };
    };

    # Install Solaar for managing Logitech devices
    hardware.logitech = {
      wireless = {
        enable = config.nixconf.peripherals.logitech;
        enableGraphical = true;
      };
    };

    services = {
      # Set sound.enable to false if pipewire, as it is only meant for ALSA-based configurations
      pulseaudio.enable = false;

      pipewire = {
        enable = true;
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
  };
}
