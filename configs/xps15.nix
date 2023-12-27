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
      gnome = false;
      greetd = {
        enable = true;
        command = "sway --unsupported-gpu";
      };
      sway = true;
      thunar = true;
    };

    gaming = {
      steam = true;
    };
  };
}
