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
      network.wireguard = {
        enable = true;
        certs = [./certs/kreo.crt];
        configs = [
          {
            kreo = {
              address = ["10.45.0.30/32"];
              dns = ["10.41.0.2"];
              privateKeyFile = "${user.home}/.ssh/wireguard/privatekey";
              peers = [
                {
                  publicKey = "4HvNXgrqfGeFkhFBXjJelFu+uDcvepN+o0bIdCgUBWw=";
                  allowedIPs = ["10.41.0.0/16" "10.42.21.0/24"];
                  endpoint = "3.74.48.98:51820";
                  persistentKeepalive = 25;
                }
              ];
            };
          }
        ];
      };
    };
  };

  home = {
    nixhome = {
      inherit user;

      term = {
        alacritty = true;
        fish = true;
        tmux = true;
      };

      browsers = {
        brave = true;
        firefox = false;
        chrome = false;
      };

      editors = {
        datagrip = false;
        pycharm = false;
      };

      neovim = {
        enable = true;
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
