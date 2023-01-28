{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixos.user;
  docker = config.nixos.virtualisation.docker;
  addGroupIf = cond: group: groups:
    if cond
    then (groups ++ [group])
    else groups;
in {
  users.users.mcst = {
    isNormalUser = true;
    description = "Nixos User";
    extraGroups = addGroupIf docker "docker" ["networkmanager" "wheel"];
  };
}
