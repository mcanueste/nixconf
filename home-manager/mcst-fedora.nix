{
  imports = [
    ./common
  ];

  config = {
    nixconf = rec {
      username = "mcst";
      stateVersion = "24.11";
      flakePath = "/home/${username}/nixconf";

      scripts.enable = true;
      browsers.brave = true;
      chat.slack = true;

      editor = {
        neovim = true;
        vscode = true;
      };

      packages = {
        todoist = true;
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
