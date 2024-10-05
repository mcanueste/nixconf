{
  imports = [
    ../default.nix
  ];

  config = {
    nixconf = {
      # username = "mcst";
      # hostname = "nixos";
      stateVersion = "24.05";
      # flakePath = "/home/${username}/Projects/personal/nixconf";

      systemd = {
        enable = true;
        sync-notes = true;
        sync-blog = true;
      };

      term = {
        starship = true;
        eza = true;
        bat = true;
        fzf = true;
        zoxide = true;
        direnv = true;
        scripts = true;
        ai = true;
        alacritty = true;
        tmux = true;
        yazi = true;
      };

      # git = {
      #   enable = true;
      #   gh = true;
      #   lazygit = true;
      # };

      editor = {
        neovim = true;
        vscode = true;
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
        aws = false;
        azure = false;
        cfssl = false;
        digital-ocean = false;
        gcloud = true;
        localstack = false;
        kubectl = true;
        k9s = true;
        minikube = true;
        kind = true;
        helm = true;
        argo = true;
        argocd = false;
      };
    };
  };
}
