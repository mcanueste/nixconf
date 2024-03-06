{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.hardware.printer = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable printer configuration";
    };

    printerDrivers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Printer drivers";
    };

    scanner = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable scanner configuration";
    };

    scannerBackends = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra scanner backends";
    };
  };

  config = {
    services = {
      # Find printers/scanners on local network
      avahi = {
        enable = config.nixconf.hardware.printer.enable;
        nssmdns4 = config.nixconf.hardware.printer.enable;
      };

      # Enable CUPS to print documents.
      printing = {
        enable = config.nixconf.hardware.printer.enable;
        drivers = lib.lists.forEach config.nixconf.hardware.printer.printerDrivers (p: pkgs."${p}");
      };
    };

    # Enable scanner backends
    hardware.sane = {
      enable = config.nixconf.hardware.printer.scanner;
      extraBackends = lib.lists.forEach config.nixconf.hardware.printer.scannerBackends (p: pkgs."${p}");
    };
  };
}
