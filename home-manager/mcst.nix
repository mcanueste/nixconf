{
  imports = [
    ./common
  ];

  config = {
    nixconf = rec {
      username = "mcst";
      stateVersion = "24.05";
      flakePath = "/home/${username}/nixconf";

      scripts = {
        enable = true;
        systemd = {
          enable = false;
          sync-notes = true;
          sync-blog = true;
        };
      };

      editor = {
        vscode = true;
        obsidian = true;
      };

      browsers = {
        brave = true;
        chrome = true;
        firefox = true;
      };

      media = {
        spotify = true;
        calibre = true;
        zotero = true;
      };

      chat = {
        slack = true;
        telegram = false;
        discord = false;
      };

      packages = {
        nerdctl = true;
        lazydocker = true;
        packer = true;
        terraform = true;
        gcloud = true;
        kubectl = true;
        k9s = true;
        k3d = true;
        helm = true;
        argo = true;
      };
    };
  };
}
