{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.container = {
    docker = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable docker";
      };

      autoPrune = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable docker auto prune";
      };
    };

    podman = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable podman";
      };

      dockerCompat = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable docker compatability";
      };
    };

    nerdctl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nerdctl";
    };

    lazydocker = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable lazydocker";
    };

    dive = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable dive";
    };
  };

  config = {
    virtualisation = {
      docker = {
        enable = config.nixconf.dev.container.docker.enable;
        autoPrune = {
          enable = config.nixconf.dev.container.docker.autoPrune;
          dates = "weekly";
        };
      };

      podman = {
        enable = config.nixconf.dev.container.podman.enable;
        dockerCompat =
          if config.nixconf.dev.container.podman.dockerCompat && config.nixconf.dev.container.docker.enable
          then throw "Docker and Podman's dockerCompat cannot be enabled at the same time"
          else config.nixconf.dev.container.podman.dockerCompat;
        defaultNetwork.settings.dns_enabled = config.nixconf.dev.container.podman.enable;
      };

      # Enable common container config files in /etc/containers
      containers.enable = config.nixconf.dev.container.docker.enable || config.nixconf.dev.container.podman.enable;
    };

    users.users.${config.nixconf.system.user}.extraGroups =
      if config.nixconf.dev.container.docker.enable
      then ["docker"]
      else [];

    home-manager.users.${config.nixconf.system.user} = {
      home.packages = builtins.filter (p: p != null) [
        pkgs.cosign

        (
          if config.nixconf.dev.container.docker.enable
          then pkgs.docker-compose
          else null
        )

        (
          if config.nixconf.dev.container.podman.enable
          then pkgs.podman-compose
          else null
        )

        (
          if config.nixconf.dev.container.nerdctl
          then pkgs.nerdctl
          else null
        )

        (
          if config.nixconf.dev.container.lazydocker
          then pkgs.lazydocker
          else null
        )

        (
          if config.nixconf.dev.container.dive
          then pkgs.dive
          else null
        )
      ];
    };
  };
}
