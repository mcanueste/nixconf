# Install Docker and docker-compose
#
# https://nixos.wiki/wiki/Docker
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.iac.docker = {
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

  config = lib.mkIf config.nixconf.dev.iac.docker.enable {
    virtualisation = {
      docker = {
        enable = true;
        autoPrune = {
          enable = config.nixconf.dev.iac.docker.dockerAutoPrune;
          dates = "weekly";
        };
      };

      # Enable common container config files in /etc/containers
      containers.enable = true;
    };

    users.users.${config.nixconf.system.user}.extraGroups = ["docker"];

    home-manager.users.${config.nixconf.system.user} = {
      home.packages = [
        pkgs.docker-compose
      ];
    };
  };
}
