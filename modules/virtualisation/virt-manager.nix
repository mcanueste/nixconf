# Install virt-manager, an UI for managing virtual machines in libvirt
#
# https://nixos.wiki/wiki/Virt-manager
{
  lib,
  config,
  ...
}: {
  options.nixconf.virtualisation = {
    virt-manager = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable virt-manager";
    };
  };

  config = lib.mkIf config.nixconf.virtualisation.virt-manager {
    virtualisation = {
      libvirtd = {
        enable = true;

        qemu =
          if config.nixconf.virtualisation.qemu == false
          then throw "nixconf.virtualisation.qemu must be set to enable virt-manager"
          else {
            ovmf.enable = true;
            runAsRoot = true;
          };

        onBoot = "ignore";
        onShutdown = "shutdown";
      };
    };

    programs.virt-manager.enable = true;

    users.users.${config.nixconf.user}.extraGroups = ["libvirtd" "qemu-libvirtd"];

    home-manager.users.${config.nixconf.user} = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };
  };
}
