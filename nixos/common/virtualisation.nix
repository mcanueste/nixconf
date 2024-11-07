{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.virtualisation = {
    qemu = pkgs.libExt.mkEnabledOption "QEMU";

    docker = {
      enable = lib.mkEnableOption "Docker";
      autoPrune = pkgs.libExt.mkEnabledOption "Docker Auto Prune";
    };

    podman = {
      enable = lib.mkEnableOption "Podman";
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
      (pkgs.libExt.mkIfElseNull config.nixconf.virtualisation.qemu pkgs.virt-viewer)
      (pkgs.libExt.mkIfElseNull config.nixconf.virtualisation.qemu pkgs.spice)
      (pkgs.libExt.mkIfElseNull config.nixconf.virtualisation.qemu pkgs.spice-gtk)
      (pkgs.libExt.mkIfElseNull config.nixconf.virtualisation.qemu pkgs.spice-protocol)
      (pkgs.libExt.mkIfElseNull config.nixconf.virtualisation.qemu pkgs.win-virtio)
      (pkgs.libExt.mkIfElseNull config.nixconf.virtualisation.qemu pkgs.win-spice)
    ];

    # enable spice-vdagent for QEMU VMs
    services.spice-vdagentd.enable = config.nixconf.virtualisation.qemu;

    virtualisation = {
      libvirtd = {
        enable = config.nixconf.virtualisation.qemu;

        qemu = {
          runAsRoot = true;
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [pkgs.OVMFFull.fd];
        };

        onBoot = "ignore";
        onShutdown = "shutdown";
      };

      # enable USB redirection for QEMU VMs
      spiceUSBRedirection.enable = config.nixconf.virtualisation.qemu;

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
  };
}
