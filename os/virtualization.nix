{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixos.virtualisation;
  isGnome = config.nixos.desktop.gnome.enable;

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
  options.nixos.virtualisation = {
    docker = lib.mkOption {
      default = true;
      description = "Enable docker";
      type = lib.types.bool;
    };

    podman = lib.mkOption {
      default = false;
      description = "Enable podman";
      type = lib.types.bool;
    };

    distrobox = lib.mkOption {
      default = true;
      description = "Enable distrobox";
      type = lib.types.bool;
    };

    virt-manager = lib.mkOption {
      default = false;
      description = "Enable virt-manager";
      type = lib.types.bool;
    };
  };

  config = {
    virtualisation = {
      docker.enable = cfg.docker;
      podman = {
        enable = cfg.podman;
        dockerCompat = cfg.podman;
        defaultNetwork.settings.dns_enabled = cfg.podman;
      };
      libvirtd.enable = cfg.virt-manager;
    };

    environment.systemPackages = filterPackages [
      (getPackageIf cfg.docker pkgs "docker-compose")
      (getPackageIf cfg.podman pkgs "podman-compose")
      (getPackageIf cfg.distrobox pkgs "distrobox")
      (getPackageIf cfg.virt-manager pkgs "virt-manager")
    ];

    programs.dconf.enable = isGnome || cfg.virt-manager;
  };
}
