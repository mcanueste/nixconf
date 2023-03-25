{
  nixos = {
    hardware.xps15 = {
      enable = true;
      swap = false;
    };
    virtualisation = {
      docker = true;
      podman = false;
      distrobox = true;
      virt-manager = false;
    };
    desktop.gnome = {
      enable = true;
    };
  };
}
