{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixconf.user;
  docker = config.nixconf.virtualisation.docker;
  addGroupIf = cond: group: groups:
    if cond
    then (groups ++ [group])
    else groups;
in {
  options.nixconf.user = {
    username = lib.mkOption {
      default = "mcst";
      description = "Username to use for configuration";
      type = lib.types.str;
    };
  };

  config = {
    users.users.${cfg.username} = {
      isNormalUser = true;
      description = "Nixos User";
      extraGroups = addGroupIf docker "docker" ["networkmanager" "wheel" "docker"];
    };
  };
}
