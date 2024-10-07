{
  imports = [
    ./common
  ];

  config = {
    nixconf = rec {
      username = "mcst";
      stateVersion = "24.05";
      flakePath = "/home/${username}/Projects/personal/nixconf";

      editor.vscode = true;

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

      guiPackages = {
        spotify = true;
        obsidian = true;
        godot = true;
      };

      flatpak = {
        chrome = true;
        brave = true;
        firefox = true;
        vlc = true;
        slack = true;
        telegram = true;
        discord = true;
        obs = true;
        audacity = true;
        gimp = true;
        calibre = true;
        zotero = true;
      };
    };
  };
}
