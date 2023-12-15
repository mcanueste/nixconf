rec {
  user = {
    username = "mcst";
    home = "/home/mcst";
  };

  desktop = {
    gnome = false;
    i3 = false;
    sway = true;
  };

  os = {
    nixos = {
      inherit user desktop;
      network = {
        hostname = "nixos";
      };
      hardware = {
        bluetooth = true;
        xps15 = {
          enable = true;
          swap = false;
        };
      };
      virtualisation = {
        docker = true;
        podman = false;
        virt-manager = true;
      };
      gaming = {
        steam = true;
      };
    };
  };

  home = {
    nixhome = {
      inherit user;

      desktop = {
        status = true;

        i3 = true;
        rofi = true;
        dunst = true;

        sway = true;
      };

      browsers = {
        brave = true;
        firefox = false;
        chrome = false;
      };

      editors = {
        datagrip = false;
        pycharm = false;
        neovim = {
          enable = true;
        };
        obsidian = true;
      };

      devops = {
        k8s = {
          kubectl = true;
          minikube = true;
        };
        hashicorp = {
          vagrant = false;
          packer = false;
          terraform = true;
        };
        cloud = {
          aws = false;
          gcloud = false;
          azure = false;
          cfssl = false;
        };
      };

      media = {
        spotify = true;
        zotero = false;
        calibre = true;
      };

      chat = {
        telegram = true;
        teams = false;
        slack = false;
        discord = true;
      };
    };
  };
}
