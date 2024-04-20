{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.system.hardware.printer = {
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
        enable = config.nixconf.system.hardware.printer.enable;
        drivers = lib.lists.forEach config.nixconf.system.hardware.printer.printerDrivers (p: pkgs."${p}");
      };
    };

    # Enable scanner backends
    hardware.sane = {
      enable = config.nixconf.system.hardware.printer.scanner;
      extraBackends = lib.lists.forEach config.nixconf.system.hardware.printer.scannerBackends (p: pkgs."${p}");
    };

    # Add user to scanner/printer group
    users.users.${config.nixconf.user}.extraGroups =
      if config.nixconf.system.hardware.printer.scanner
      then ["scanner" "lp"]
      else [];

    # Find printers/scanners on local network
    services = {
      avahi = let
        enable = config.nixconf.system.hardware.printer.enable || config.nixconf.system.hardware.printer.scanner;
      in {
        inherit enable;
        nssmdns4 = enable;
        openFirewall = enable;
      };
    };
  };
}
