{ pkgs, ... }:
{
  users.users.mcst = {
    isNormalUser = true;
    description = "mcst";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      brave
    ];
  };
}
