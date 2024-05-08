{
  nixconf = {
    user = "mcst";

    system = {
      hardware = {
        boot = {
          intelMicrocode = true;
          cpuFreqGovernor = "ondemand";
        };
        nvidia = {
          enable = true;
          isTuring = true;
        };
        peripherals = {
          bluetooth = true;
          logitech = true;
        };
        printer = {
          enable = false;
          scanner = false;
        };
      };

      network = {
        hostname = "nixos";
        hosts = "";
        firewall = {
          enable = true;
          allowedTCPPorts = [];
          allowedTCPPortRanges = [];
          allowedUDPPorts = [];
          allowedUDPPortRanges = [];
        };
        wireguard = {
          enable = false;
          configs = [];
        };
        mtr = {
          enable = true;
          exportMtr = false;
        };
      };

      service = {
        power = {
          thermald = true;
          power-profiles-daemon = true;
        };
        dbus = {
          enable = true;
          tumbler = true;
        };
        storage = {
          trim = true;
          hdapsd = false;
          gvfs = true;
          udisk2 = true;
        };
        sound = {
          pipewire = true;
        };
      };

      desktop = {
        enable = true;
        de.gnome = false;
        wm = {
          enable = true;
          blueman = true;
          networkmanager = true;
          kanshi = true;
          login.greetd = {
            enable = true;
            command = "Hyprland";
          };
          tiling.hyprland = true;
          bar.waybar = true;
          launcher.rofi = true;
          notification.swaync = true;
        };
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
      firefox = true;
      chrome = true;
    };

    media = {
      zotero = false;
      calibre = true;
      obsidian = true;
      zathura = true;
      gimp = true;
      obs = true;
      audacity = true;
      qpwgraph = true;
      vlc = true;
      spotify = true;
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

      editor = {
        neovim = true;
        vscode = true;
        datagrip = false;

        pycharm = {
          enable = false;
          professional = false;
        };
      };
    };
  };
}
