{
  imports = [
    ./common
  ];

  config = {
    nixconf = rec {
      username = "mcst";
      stateVersion = "24.05";
      flakePath = "/home/${username}/nixconf";

      editor = {
        vscode = true;
        obsidian = true;
      };

      scripts = {
        enable = true;
        systemd = {
          enable = false;
          sync-notes = true;
          sync-blog = true;
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
        gcloud = true;
        kubectl = true;
        k9s = true;
        k3d = true;
        helm = true;
        argo = true;
      };

      browsers = {
        brave = true;
        chrome = true;
        firefox = true;
      };

      media = {
        spotify = true;
        vlc = false;
        obs = false;
        audacity = false;
        gimp = false;
        calibre = true;
        zotero = true;
      };

      chat = {
        slack = true;
        telegram = false;
        discord = false;
      };
    };
  };
}
