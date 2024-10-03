{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.hardware.printer = {
    enable = lib.mkEnableOption "Printer Configuration";

    printerDrivers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Printer drivers";
    };

    scanner = lib.mkEnableOption "Scanner Configuration";

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
        enable = config.nixconf.hardware.printer.enable;
        drivers = lib.lists.forEach config.nixconf.hardware.printer.printerDrivers (p: pkgs."${p}");
      };
    };

    # Enable scanner backends
    hardware.sane = {
      enable = config.nixconf.hardware.printer.scanner;
      extraBackends = lib.lists.forEach config.nixconf.hardware.printer.scannerBackends (p: pkgs."${p}");
    };

    # Add user to scanner/printer group
    users.users.${config.nixconf.user}.extraGroups =
      if config.nixconf.hardware.printer.scanner
      then ["scanner" "lp"]
      else if config.nixconf.hardware.printer.enable
      then ["lp"]
      else [];

    # Find printers/scanners on local network
    services = {
      avahi = let
        enable = config.nixconf.hardware.printer.enable || config.nixconf.hardware.printer.scanner;
      in {
        inherit enable;
        nssmdns4 = enable;
        openFirewall = enable;
      };
    };
  };
}
