rec {
  user = {
    username = "mcst";
    home = "/home/mcst";
  };

  os = {
    nixos = {
      inherit user;
      hardware.xps15 = {
        enable = true;
        swap = false;
      };
      virtualisation = {
        docker = true;
        podman = false;
        distrobox = true;
        virt-manager = true;
      };
      desktop = {
        gnome = {
          enable = true;
        };
        i3 = {
          enable = true;
        };
      };
    };
  };

  home = {
    nixhome = {
      inherit user;

      browsers = {
        brave = true;
        firefox = false;
        chrome = false;
      };

      term = {
        alacritty = true;
        fish = true;
        tmux = true;
      };

      editors = {
        datagrip = false;
        pycharm = false;
        neovim = {
          enable = true;
        };
      };

      dev = {
        go = {
          enable = true;
          hugo = true;
        };
        python = {
          enable = false;
          poetry = false;
        };
      };

      devops = {
        k8s = {
          kubectl = true;
          minikube = true;
        };
        hashicorp = {
          vagrant = true;
          packer = true;
          terraform = true;
        };
        cloud = {
          aws = false;
          gcloud = false;
          azure = false;
          cfssl = false;
        };
      };

      tools = {
        direnv = false;
      };

      media = {
        spotify = true;
        zotero = true;
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
