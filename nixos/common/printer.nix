{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.printer = {
    enable = pkgs.libExt.mkEnabledOption "Printer Configuration";

    printerDrivers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["cups-dymo" "brlaser"];
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
        enable = config.nixconf.printer.enable;
        drivers = lib.lists.forEach config.nixconf.printer.printerDrivers (p: pkgs."${p}");
      };
    };

    # Enable scanner backends
    hardware.sane = {
      enable = config.nixconf.printer.scanner;
      extraBackends = lib.lists.forEach config.nixconf.printer.scannerBackends (p: pkgs."${p}");
    };

    # Add user to scanner/printer group
    users.users.${config.nixconf.username}.extraGroups =
      if config.nixconf.printer.scanner
      then ["scanner" "lp"]
      else if config.nixconf.printer.enable
      then ["lp"]
      else [];

    # Find printers/scanners on local network
    services = {
      avahi = let
        enable = config.nixconf.printer.enable || config.nixconf.printer.scanner;
      in {
        inherit enable;
        nssmdns4 = enable;
        openFirewall = enable;
      };
    };
  };
}
