{
  nixconf = {
    user = "mcst";
    system.network.hostname = "nixos";

    hardware = {
      boot.swap = true;
      nvidia = true;
      logitech = true;
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

    term = {
      starship = true;
      eza = true;
      bat = true;
      fzf = true;
      zoxide = true;
      direnv = true;
      scripts = true;

      systemd = {
        enable = true;
        sync-notes = true;
        sync-blog = true;
      };

      ai = true;
      alacritty = true;
      tmux = true;
    };

    browser = {
      brave = true;
      firefox = true;
      chrome = true;
    };

    media = {
      spotify = true;
      zotero = false;
      calibre = true;
    };

    chat = {
      telegram = true;
      discord = true;
      slack = true;
      teams = false;
    };

    gaming = {
      steam = false;
    };

    dev = {
      git = true;
      lazygit = true;

      virtualisation = {
        qemu = true;
        virt-manager = true;
      };

      iac = {
        docker = {
          enable = true;
          dockerAutoPrune = true;
        };

        podman = {
          enable = false;
          dockerCompat = false;
        };

        lazydocker = true;
        dive = true;
        packer = true;
        minikube = true;
        kubectl = true;
        k9s = true;
        terraform = true;
        localstack = false;
        aws = false;
        gcloud = true;
        azure = false;
        digital-ocean = false;
        cfssl = false;
      };
    };

    editor = {
      neovim = true;
      obsidian = true;
      vscode = true;
    };
  };
}
