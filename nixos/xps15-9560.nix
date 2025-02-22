{
  imports = [
    ./common
    ./processor/intel-cpu.nix
    ./processor/intel-igpu.nix
    ./processor/nvidia.nix
  ];

  config = {
    nixconf = {
      username = "homeserver";
      hostname = "homeserver";
      stateVersion = "24.11";

      filesystem = {
        boot = "/dev/disk/by-partlabel/EFI";
        root = "/dev/disk/by-partlabel/root";
        swap = "/dev/disk/by-label/swap";
        encrypted = false;
      };

      desktop.cosmic = false;
      gaming.enable = true;

      nvidia = {
        enable = true;
        isTuring = false;
        sync = false; # use offload, sync causes issues with wayland and browsers
      };

      virtualisation = {
        docker = {
          enable = true;
          autoPrune = true;
        };
      };
    };
  };
}
