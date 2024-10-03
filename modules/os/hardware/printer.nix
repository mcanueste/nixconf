{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.os.hardware.printer = {
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
      # Enable CUPS to print documents.
      printing = {
        enable = config.nixconf.os.hardware.printer.enable;
        drivers = lib.lists.forEach config.nixconf.os.hardware.printer.printerDrivers (p: pkgs."${p}");
      };
    };

    # Enable scanner backends
    hardware.sane = {
      enable = config.nixconf.os.hardware.printer.scanner;
      extraBackends = lib.lists.forEach config.nixconf.os.hardware.printer.scannerBackends (p: pkgs."${p}");
    };

    # Add user to scanner/printer group
    users.users.${config.nixconf.os.user}.extraGroups =
      if config.nixconf.os.hardware.printer.scanner
      then ["scanner" "lp"]
      else if config.nixconf.os.hardware.printer.enable
      then ["lp"]
      else [];

    # Find printers/scanners on local network
    services = {
      avahi = let
        enable = config.nixconf.os.hardware.printer.enable || config.nixconf.os.hardware.printer.scanner;
      in {
        inherit enable;
        nssmdns4 = enable;
        openFirewall = enable;
      };
    };
  };
}
