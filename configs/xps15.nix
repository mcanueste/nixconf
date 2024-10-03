{
  nixconf = {
    os = {
      user = "mcst";

      hardware = {
        nvidia = {
          enable = true;
          isTuring = true;
          sync = false; # use offload, sync causes issues with wayland and browsers
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
      };

      network = {
        hostname = "nixos";
        firewall.enable = true;
        wireguard.enable = false;
        mtr = {
          enable = true;
          exportMtr = false;
        };
      };

      service = {
        kanata = true;

        flatpak = {
          enable = true;

          chrome = true;
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

        storage = {
          trim = true;
          gvfs = true;
          udisk2 = true;
        };
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
      yazi = true;
    };

    browser = {
      brave = true;
    };

    dev = {
      git = {
        enable = true;
        gh = true;
        lazygit = true;
      };

      languages = {
        just = true;
        pre-commit = true;
        python = true;
        rust = true;
        go = true;
      };

      editor = {
        neovim = true;
        vscode = true;
        datagrip = false;
        helix = false;

        pycharm = {
          enable = false;
          professional = false;
        };
      };

      virtualisation = {
        qemu = true;
        virt-manager = true;
      };

      iac = {
        packer = true;
        terraform = true;
      };

      container = {
        docker = {
          enable = true;
          autoPrune = true;
        };

        podman = {
          enable = false;
          dockerCompat = false;
        };

        nerdctl = true;
        lazydocker = true;
        dive = true;
      };

      cicd = {
        argo = true;
        argocd = true;
      };

      k8s = {
        kubectl = true;
        k9s = true;
        minikube = true;
        kind = true;
        helm = true;
      };

      cloud = {
        aws = false;
        azure = false;
        cfssl = false;
        digital-ocean = false;
        gcloud = true;
        localstack = false;
      };
    };
  };
}
