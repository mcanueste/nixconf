{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.virtualisation = {
    qemu = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable qemu";
    };

    virt-manager = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable virt-manager";
    };
  };

  config = {
    services.qemuGuest.enable = config.nixconf.dev.virtualisation.qemu;

    programs.virt-manager.enable = config.nixconf.dev.virtualisation.virt-manager;

    users.users.${config.nixconf.os.user}.extraGroups =
      if config.nixconf.dev.virtualisation.virt-manager
      then ["libvirtd" "qemu-libvirtd"]
      else [];

    virtualisation = {
      libvirtd = {
        enable = config.nixconf.dev.virtualisation.virt-manager;

        qemu =
          if config.nixconf.dev.virtualisation.qemu == false
          then throw "nixconf.dev.virtualisation.qemu must be set to enable virt-manager"
          else {
            ovmf.enable = true;
            runAsRoot = true;
          };

        onBoot = "ignore";
        onShutdown = "shutdown";
      };
    };

    home-manager.users.${config.nixconf.os.user} = {
      home.packages = builtins.filter (p: p != null) [
        (
          if config.nixconf.dev.virtualisation.qemu
          then pkgs.qemu
          else null
          # pkgs.quickemu # does not build due to maturin
          # pkgs.quickgui # Not really useful
        )
      ];

      dconf.settings = lib.mkIf config.nixconf.dev.virtualisation.virt-manager {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };
  };
}
