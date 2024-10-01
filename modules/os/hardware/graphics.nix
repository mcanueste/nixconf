{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.hardware.graphics = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable graphics configuration";
    };
  };

  config = lib.mkIf config.nixconf.system.hardware.graphics.enable {
    # intel gpu video acceleration setup
    # https://nixos.wiki/wiki/Accelerated_Video_Playback

    nixpkgs.config.packageOverrides = pkg: {
      intel-vaapi-driver = pkg.intel-vaapi-driver.override {enableHybridCodec = true;};
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD hardware newer than 2014 should use this
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965
        intel-ocl
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        intel-media-driver
        intel-vaapi-driver
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
