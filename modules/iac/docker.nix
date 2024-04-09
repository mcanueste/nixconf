# Install Docker and docker-compose
#
# https://nixos.wiki/wiki/Docker
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.iac.docker = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable docker";
    };

    dockerAutoPrune = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable docker weekly auto prune";
    };
  };

  config = lib.mkIf config.nixconf.iac.docker.enable {
    virtualisation = {
      docker = {
        enable = true;
        autoPrune = {
          enable = config.nixconf.iac.docker.dockerAutoPrune;
          dates = "weekly";
        };
      };

      # Enable common container config files in /etc/containers
      containers.enable = true;
    };

    users.users.${config.nixconf.user}.extraGroups = ["docker"];

    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.docker-compose
      ];
    };
  };
}
