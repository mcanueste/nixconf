{
  pkgs,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixos.virtualisation;
in {
  options.nixos.virtualisation = {
    docker = mkBoolOption {description = "Enable docker";};
    podman = mkBoolOption {
      description = "Enable podman";
      default = false;
    };
    virt-manager = mkBoolOption {
      description = "Enable virt-manager";
      default = false;
    };
  };

  config = {
    programs.dconf.enable = true;
    services.qemuGuest.enable = true;
    virtualisation = {
      docker.enable = cfg.docker;
      podman = {
        enable = cfg.podman;
        dockerCompat = cfg.podman;
        defaultNetwork.settings.dns_enabled = cfg.podman;
      };
      libvirtd = {
        enable = cfg.virt-manager;
        qemu = {
          ovmf.enable = true;
          runAsRoot = true;
        };
        onBoot = "ignore";
        onShutdown = "shutdown";
      };
    };

    environment.systemPackages = filterPackages [
      (getPackageIf cfg.docker pkgs.docker-compose)
      (getPackageIf cfg.podman pkgs.podman-compose)
      (getPackageIf cfg.virt-manager pkgs.virt-manager)
    ];
  };
}
