{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixconf.virtualisation;

  getPackage = pkgs: pname:
    with builtins;
      if hasAttr pname pkgs
      then getAttr pname pkgs
      else getAttr pname pkgs;

  getPackageIf = cond: pkgs: pname:
    if cond
    then getPackage pkgs pname
    else null;

  filterPackages = packages: with builtins; filter (p: ! isNull p) packages;
in {
  options.nixconf.virtualisation = {
    docker = lib.mkOption {
      default = true;
      description = "Enable docker";
      type = lib.types.bool;
    };

    dockerCompose = lib.mkOption {
      default = true;
      description = "Enable docker-compose";
      type = lib.types.bool;
    };

    podman = lib.mkOption {
      default = false;
      description = "Enable podman";
      type = lib.types.bool;
    };

    podmanDockerCompat = lib.mkOption {
      default = false;
      description = "Enable podman";
      type = lib.types.bool;
    };

    podmanCompose = lib.mkOption {
      default = false;
      description = "Enable podman-compose";
      type = lib.types.bool;
    };
  };

  config = {
    virtualisation = {
      docker.enable = cfg.docker;
      podman = {
        enable = cfg.podman;
        dockerCompat = cfg.podmanDockerCompat;
        defaultNetwork.settings.dns_enabled = cfg.podmanCompose;
      };
    };

    environment.systemPackages = filterPackages [
      (getPackageIf cfg.dockerCompose pkgs "docker-compose")
      (getPackageIf cfg.podmanCompose pkgs "podman-compose")
    ];
  };
}
