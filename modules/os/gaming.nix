{
  lib,
  config,
  ...
}: {
  options.nixconf.gaming = {
    steam = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable steam";
    };
  };

  config = lib.mkIf config.nixconf.gaming.steam {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
  };
}
