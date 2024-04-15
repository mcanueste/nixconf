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
    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkg:
          with pkg; [
            gamescope
            mangohud
          ];
      };
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
  };
}
