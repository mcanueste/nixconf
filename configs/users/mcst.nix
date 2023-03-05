{
  users.users.mcst = {
    isNormalUser = true;
    home = "/home/mcst";
    description = "mcst";
    extraGroups = ["wheel" "networkmanager" "docker" "libvirtd"];
  };
}
