# TODO: assumes intel, can be AMD or ARM as well?
{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./nvidia.nix
  ];

  options.nixconf.graphics.enable = pkgs.libExt.mkEnabledOption "Graphics Configuration";

  config = lib.mkIf config.nixconf.graphics.enable {
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
    services.xserver.videoDrivers = ["intel"];

    # Graphics related tools
    environment.systemPackages = with pkgs; [
      libva-utils
      glxinfo
    ];
  };
}