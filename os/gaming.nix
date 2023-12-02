{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixos.gaming;
in {
  options.nixos.gaming = {
    steam = mkBoolOption {description = "Enable steam";};
  };

  config = {
    programs.steam = {
      enable = cfg.steam;
      remotePlay.openFirewall = cfg.steam; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = cfg.steam; # Open ports in the firewall for Source Dedicated Server
    };
    # environment.systemPackages = with pkgs; [
    #   steam
    #   steam-original
    #   steam-run
    # ];
  };
}
