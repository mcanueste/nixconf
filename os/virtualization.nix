{
  pkgs,
  lib,
  config,
  ...
}:
with lib.conflib; let
  cfg = config.nixos.virtualisation;
  isGnome = config.nixos.desktop.gnome.enable;
in {
  options.nixos.virtualisation = {
    docker = mkBoolOption {description = "Enable docker";};
    podman = mkBoolOption {
      description = "Enable podman";
      default = false;
    };
    distrobox = mkBoolOption {description = "Enable distrobox";};
    virt-manager = mkBoolOption {
      description = "Enable virt-manager";
      default = false;
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
