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
        notes = true;
        systemd = true;
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

      chat.slack = true;

      packages = {
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
