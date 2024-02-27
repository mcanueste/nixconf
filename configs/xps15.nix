{
  nixconf = {
    user = "mcst";
    network.hostname = "nixos";

    hardware = {
      xps15 = {
        enable = true;
        swap = false;
      };
      logitech = true;
    };

    virtualisation = {
      docker = true;
      dockerAutoPrune = true;
      virt-manager = true;
      podman = false;
    };

    desktop = {
      enable = true;
      gnome = false;
      greetd = {
        enable = true;
        command = "Hyprland";
      };
      hyprland = true;
      waybar = true;
      swaync = true;
      rofi = true;
    };

    browser = {
      brave = true;
      firefox = true;
    };

    gaming = true;

    tools = {
      k9s = true;
      kubectl = true;
      localstack = false;
      lazydocker = true;
      lazygit = true;
      minikube = true;
      packer = false;
      terraform = true;
      todoist = true;
      vagrant = false;

      # Cloud CLIs
      aws = true;
      gcloud = false;
      azure = false;
      digital-ocean = false;
      cfssl = false;
    };

    editor = {
      neovim = true;
      obsidian = true;
    };
  };
}
