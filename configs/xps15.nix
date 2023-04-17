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
        virt-manager = false;
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
      fish.enable = true;
      tmux.enable = false;
      zellij.enable = false;

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

      devops = {
        k8s = {
          kubectl = true;
          minikube = true;
        };
        hashicorp = {
          terraform = true;
          packer = true;
        };
        cloud = {
          aws = false;
          gcloud = false;
          azure = false;
          cfssl = false;
        };
      };

      gui-tools = {
        zotero = true;
        todoist = true;
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
