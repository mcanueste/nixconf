{
  nixconf = {
    user = "mcst";

    hardware = {
      xps15 = {
        enable = true;
        swap = false;
      };
    };

    network = {
      hostname = "nixos";
      hosts = "";
      wireguard = {
        enable = false;
        configs = [];
      };
      exportMtr = false;
    };

    security = {
      certs = [];
      openssh = false;
      sftp = false;
      sshd = false;
      gvfs = true;
    };

    printer = {
      enable = false;
      printerDrivers = [];
      scanner = false;
      scannerBackends = [];
    };

    virtualisation = {
      docker = true;
      podman = false;
      virt-manager = true;
    };

    desktop = {
      enable = true;
      gnome = false;
      greetd = {
        enable = true;
        command = "Hyprland";
      };
      hyprland = true;
      swaync = true;
    };

    gaming = {
      steam = true;
    };
  };
}
