{
  imports = [
    ../common
    ../processor/intel-cpu.nix
    ../processor/intel-igpu.nix
    ../processor/nvidia.nix
  ];

  config = {
    nixconf = rec {
      username = "mcst";
      hostname = "nixos";
      stateVersion = "24.05";
      flakePath = "/home/${username}/Projects/personal/nixconf";

      gaming.enable = true;

      nvidia = {
        enable = true;
        isTuring = true;
        sync = false; # use offload, sync causes issues with wayland and browsers
      };

      flatpak = {
        enable = true;
        chrome = true;
        brave = true;
        firefox = true;
        vlc = true;
        spotify = true;
        slack = true;
        telegram = true;
        discord = true;
        obs = true;
        audacity = true;
        gimp = true;
        calibre = true;
        zotero = true;
        obsidian = true;
      };
    };
  };
}
