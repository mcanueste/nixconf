{
  nixconf = {
    user = "mcst";
    network.hostname = "nixos";

    hardware = {
      boot.swap = true;
      nvidia = true;
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
      chrome = true;
    };

    gaming = false;

    tools = {
      k9s = true;
      kubectl = true;
      localstack = false;
      lazydocker = true;
      lazygit = true;
      minikube = true;
      packer = true;
      terraform = true;
      todoist = true;
      vagrant = false;

      # Cloud CLIs
      aws = true;
      gcloud = true;
      azure = false;
      digital-ocean = false;
      cfssl = false;
    };

    editor = {
      neovim = true;
      obsidian = true;
      vscode = true;
    };

    chat = {
      slack = true;
    };
  };
}
