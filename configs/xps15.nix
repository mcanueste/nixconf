{
  nixconf = {
    system = {
      user = "mcst";

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
          enable = true;
          printerDrivers = [ "cups-dymo" ];
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
        de.gnome = true;
        wm = {
          enable = true;
          blueman = true;
          networkmanager = true;
          kanshi = true;
          login.greetd = {
            enable = false;
            command = "Hyprland";
          };
          tiling.hyprland = true;
          bar.waybar = true;
          launcher.rofi = true;
          notification.swaync = true;
        };
      };

      intune = true;
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
      zathura = true;
      obsidian = true;
      zotero = true;
      calibre = true;
      gimp = true;
      spotify = true;
      vlc = true;
      qpwgraph = true;
      audacity = true;
      obs = true;
    };

    chat = {
      telegram = true;
      discord = true;
      slack = true;
      teams = false;
    };

    gaming = {
      steam = true;
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
