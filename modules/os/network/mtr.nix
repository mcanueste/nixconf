{
  lib,
  config,
  ...
}: {
  options.nixconf.system.network.mtr = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable My Traceroute (mtr) network diagnostic tool";
    };

    exportMtr = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Prometheus-ready mtr exporter";
    };
  };

  config = lib.mkIf config.nixconf.system.network.mtr.enable {
    # network diagnostic tool (requires sudo) = ping + traceroute
    programs.mtr.enable = true;
    services.mtr-exporter.enable = config.nixconf.system.network.mtr.exportMtr;
  };
}
