{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.packages = {
    cachix = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable cachix";
    };
  };

  config = {
    # OS level packages
    environment.systemPackages = builtins.filter (p: p != null) [
      pkgs.coreutils-full
      pkgs.curl
      pkgs.wget
      pkgs.lsof
      pkgs.pciutils
      pkgs.lshw
      pkgs.gzip
      pkgs.unzip
      pkgs.xdg-utils

      (
        if config.nixconf.system.packages.cachix
        then pkgs.cachix
        else null
      )
    ];
  };
}
