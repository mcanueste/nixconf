{
  pkgs,
  lib,
  config,
  ...
}: let
  nvidia-offload = pkgs.writeShellApplication {
    name = "nvidia-offload";
    runtimeInputs = [];
    text = ''
      #!/usr/bin/env bash
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '';
  };
in {
  options.nixconf = {
    gaming = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable gaming";
    };
  };

  config = lib.mkIf config.nixconf.gaming {
    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkg:
          with pkg; [
            gamescope
            mangohud
          ];
      };
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        nvidia-offload
      ];
    };
  };
}
