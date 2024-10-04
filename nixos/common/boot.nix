{
  pkgs,
  config,
  ...
}: {
  options.nixconf.boot = {
    # Disable this on VM's
    thermald = pkgs.libExt.mkEnabledOption "Thermald. Only disable on VM's";
  };

  config = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi = {
          canTouchEfiVariables = true;
        };
      };

      # TODO: move to device specific config
      # power_save - works well on this card - disable if there are issues
      extraModprobeConfig = ''
        options iwlwifi power_save=1
      '';
    };

    services = {
      # This will save you money and possibly your life!
      thermald.enable = config.nixconf.boot.thermald;

      # Enable power-profiles-daemon for switching power profiles
      power-profiles-daemon.enable = true;
    };
  };
}
