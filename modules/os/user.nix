{
  lib,
  config,
  ...
}: let
  cfg = config.nixos.user;
in {
  options.nixos.user = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "mcst";
      description = "Username";
    };

    home = lib.mkOption {
      type = lib.types.str;
      default = "/home/mcst";
      description = "User home path";
    };
  };

  config = {
    users.users.${cfg.username} = {
      isNormalUser = true;
      home = "${cfg.home}";
      description = "${cfg.username}";
      extraGroups = ["wheel" "video" "audio" "disk" "networkmanager" "docker" "libvirtd" "qemu-libvirtd"];
    };
  };
}
