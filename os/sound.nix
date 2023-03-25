{
  pkgs,
  lib,
  config,
  ...
}: {
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = false;
    extraModules = [pkgs.ldacbt];
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
