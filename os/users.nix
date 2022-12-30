{ pkgs, ... }:
{
  users.users.mcst = {
    isNormalUser = true;
    description = "mcst";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
      brave
    ];
  };
}
