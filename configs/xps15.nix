{
  nixconf = rec {
    username = "mcst";
    hostname = "nixos";
    stateVersion = "24.05";
    flakePath = "/home/${username}/Projects/personal/nixconf";

    network = {
      firewall.enable = true;
      wireguard.enable = false;
      mtr = {
        enable = true;
        exportMtr = false;
      };
    };

    peripherals = {
      touchpad = true;
      bluetooth = true;
      logitech = true;
    };

    printer = {
      enable = true;
      printerDrivers = ["cups-dymo"];
      scanner = false;
    };

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

    desktop = {
      enable = true;
      gnome = true;
      cosmic = true;
    };

    gaming = {
      enable = true;
      steam = true;
      proton = true;
      prismlauncher = true;
    };

    kanata = true;

    systemd = {
      enable = true;
      sync-notes = true;
      sync-blog = true;
    };

    term = {
      starship = true;
      eza = true;
      bat = true;
      fzf = true;
      zoxide = true;
      direnv = true;
      scripts = true;
      ai = true;
      alacritty = true;
      tmux = true;
      yazi = true;
    };

    git = {
      enable = true;
      gh = true;
      lazygit = true;
    };

    editor = {
      neovim = true;
      vscode = true;
    };

    virtualisation = {
      qemu = true;

      docker = {
        enable = true;
        autoPrune = true;
      };

      podman = {
        enable = true;
        dockerCompat = false;
      };
    };

    packages = {
      pre-commit = true;
      docker-compose = true;
      podman-compose = true;
      nerdctl = true;
      lazydocker = true;
      dive = true;
      cosign = true;
      packer = true;
      terraform = true;
      aws = false;
      azure = false;
      cfssl = false;
      digital-ocean = false;
      gcloud = true;
      localstack = false;
      kubectl = true;
      k9s = true;
      minikube = true;
      kind = true;
      helm = true;
      argo = true;
      argocd = false;
    };
  };
}
