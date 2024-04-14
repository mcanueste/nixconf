# Install QEMU and QuickEMU, in addition to Qemu Guest Service
#
# https://nixos.wiki/wiki/QEMU
# https://github.com/quickemu-project/quickemu
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/qemu-guest-agent.nix
# https://www.reddit.com/r/Proxmox/comments/tzyxt2/eli5_when_should_use_qemu_guest_agent/
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
  };

  config = lib.mkIf config.nixconf.dev.virtualisation.qemu {
    services.qemuGuest.enable = true;

    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.qemu
        pkgs.quickemu
        # pkgs.quickgui # Not really useful
      ];
    };
  };
}
