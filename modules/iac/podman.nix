# Install Podman and podman-compose
#
# Note: Using `dockerCompat` option might conflict with `docker` if it is also enabled.
#
# https://nixos.wiki/wiki/Podman
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.iac.podman = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable podman";
    };

    dockerCompat = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable docker compatibility mode";
    };
  };

  config = lib.mkIf config.nixconf.iac.podman.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat =
          if config.nixconf.iac.podman.dockerCompat && config.nixconf.iac.docker.enable
          then throw "Docker and Podman's dockerCompat cannot be enabled at the same time"
          else config.nixconf.iac.podman.dockerCompat;
        defaultNetwork.settings.dns_enabled = true;
      };

      # Enable common container config files in /etc/containers
      containers.enable = true;
    };

    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.podman-compose
      ];
    };
  };
}
