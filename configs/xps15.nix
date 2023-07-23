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
        virt-manager = true;
      };
      desktop = {
        gnome = false;
        i3 = false;
        greetd = true;
        sway = true;
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
