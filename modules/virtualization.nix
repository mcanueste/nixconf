{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.virtualisation = {
    qemu = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable qemu";
    };

    docker = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable docker";
    };
    dockerAutoPrune = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable docker weekly auto prune";
    };

    podman = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable podman";
    };

    virt-manager = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable virt-manager";
    };
  };

  config = {
    services.qemuGuest.enable = config.nixconf.virtualisation.qemu;

    virtualisation = {
      docker = {
        enable = config.nixconf.virtualisation.docker;
        autoPrune = {
          enable = config.nixconf.virtualisation.dockerAutoPrune;
          dates = "weekly";
        };
      };

      podman = {
        enable = config.nixconf.virtualisation.podman;
        dockerCompat = config.nixconf.virtualisation.podman;
        defaultNetwork.settings.dns_enabled = config.nixconf.virtualisation.podman;
      };

      libvirtd = {
        enable = config.nixconf.virtualisation.virt-manager;

        qemu = {
          ovmf.enable = config.nixconf.virtualisation.qemu;
          runAsRoot = config.nixconf.virtualisation.qemu;
        };

        onBoot = "ignore";
        onShutdown = "shutdown";
      };
    };

    users.users.${config.nixconf.user}.extraGroups = builtins.filter (p: p != "") [
      (lib.strings.optionalString config.nixconf.virtualisation.docker "docker")
      (lib.strings.optionalString config.nixconf.virtualisation.virt-manager "libvirtd")
      (lib.strings.optionalString config.nixconf.virtualisation.virt-manager "qemu-libvirtd")
    ];

    environment.systemPackages = lib.lists.flatten [
      (lib.lists.optional config.nixconf.virtualisation.docker pkgs.docker-compose)
      (lib.lists.optional config.nixconf.virtualisation.podman pkgs.podman-compose)
      (lib.lists.optional config.nixconf.virtualisation.virt-manager pkgs.virt-manager)
    ];
  };
}
