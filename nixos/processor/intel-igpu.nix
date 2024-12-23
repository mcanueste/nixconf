{
  pkgs,
  lib,
  config,
  ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD hardware newer than 2014 should use this
      intel-ocl
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      intel-media-driver
    ];
  };

  # Set VDPAU driver for intel gpu
  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  # Enable GPU drivers
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  # Graphics related tools
  environment.systemPackages = with pkgs; [
    libva-utils
    glxinfo
  ];
}
