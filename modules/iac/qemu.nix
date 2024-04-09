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
  options.nixconf.virtualisation = {
    qemu = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable qemu";
    };
  };

  config = lib.mkIf config.nixconf.virtualisation.qemu {
    services.qemuGuest.enable = true;
    environment.systemPackages = [pkgs.qemu pkgs.quickemu];
  };
}
