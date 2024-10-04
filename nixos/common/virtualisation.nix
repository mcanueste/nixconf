{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.virtualisation = {
    qemu = pkgs.libExt.mkEnabledOption "QEMU";

    docker = {
      enable = pkgs.libExt.mkEnabledOption "Docker";
      autoPrune = pkgs.libExt.mkEnabledOption "Docker Auto Prune";
    };

    podman = {
      enable = pkgs.libExt.mkEnabledOption "Podman";
      dockerCompat = lib.mkEnableOption "Docker Compatability";
    };
  };

  config = {
    services.qemuGuest.enable = config.nixconf.virtualisation.qemu;

    programs.virt-manager.enable = config.nixconf.virtualisation.qemu;

    users.users.${config.nixconf.username}.extraGroups = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.virtualisation.qemu "libvirtd")
      (pkgs.libExt.mkIfElseNull config.nixconf.virtualisation.qemu "qemu-libvirtd")
      (pkgs.libExt.mkIfElseNull config.nixconf.virtualisation.docker.enable "docker")
    ];

    environment.systemPackages = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.virtualisation.qemu pkgs.qemu)
    ];

    virtualisation = {
      libvirtd = {
        enable = config.nixconf.virtualisation.qemu;

        qemu = {
          ovmf.enable = true;
          runAsRoot = true;
        };

        onBoot = "ignore";
        onShutdown = "shutdown";
      };

      docker = {
        enable = config.nixconf.virtualisation.docker.enable;
        autoPrune = {
          enable = config.nixconf.virtualisation.docker.autoPrune;
          dates = "weekly";
        };
      };

      podman = {
        enable = config.nixconf.virtualisation.podman.enable;
        dockerCompat =
          if config.nixconf.virtualisation.podman.dockerCompat && config.nixconf.virtualisation.docker.enable
          then throw "Docker and Podman's dockerCompat cannot be enabled at the same time"
          else config.nixconf.virtualisation.podman.dockerCompat;
        defaultNetwork.settings.dns_enabled = config.nixconf.virtualisation.podman.enable;
      };

      # Enable common container config files in /etc/containers
      containers.enable = config.nixconf.virtualisation.docker.enable || config.nixconf.virtualisation.podman.enable;
    };

    home-manager.users.${config.nixconf.username} = {
      dconf.settings = lib.mkIf config.nixconf.virtualisation.qemu {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };
  };
}
