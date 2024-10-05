{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.packages = {
    pre-commit = lib.mkEnableOption "Pre-commit";

    docker-compose = lib.mkEnableOption "Docker Compose";

    podman-compose = lib.mkEnableOption "Podman Compose";

    nerdctl = lib.mkEnableOption "Nerdctl";

    lazydocker = lib.mkEnableOption "Lazydocker";

    dive = lib.mkEnableOption "Dive";

    cosign = lib.mkEnableOption "Cosign";

    packer = lib.mkEnableOption "Packer";

    terraform = lib.mkEnableOption "Terraform";

    aws = lib.mkEnableOption "AWS CLI";

    azure = lib.mkEnableOption "Azure CLI";

    cfssl = lib.mkEnableOption "CFSSL";

    digital-ocean = lib.mkEnableOption "Digital Ocean CLI";

    gcloud = lib.mkEnableOption "Google Cloud CLI";

    localstack = lib.mkEnableOption "Localstack CLI";

    kubectl = lib.mkEnableOption "Kubectl";

    k9s = lib.mkEnableOption "K9s";

    minikube = lib.mkEnableOption "Minikube";

    kind = lib.mkEnableOption "Kind";

    helm = lib.mkEnableOption "Helm";

    argo = lib.mkEnableOption "Argo CLI";

    argocd = lib.mkEnableOption "ArgoCD CLI";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.pre-commit pkgs.pre-commit)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.docker-compose pkgs.docker-compose)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.podman-compose pkgs.podman-compose)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.nerdctl pkgs.nerdctl)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.lazydocker pkgs.lazydocker)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.dive pkgs.dive)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.cosign pkgs.cosign)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.packer pkgs.packer)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.terraform pkgs.terraform)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.aws pkgs.awscli2)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.azure pkgs.azure-cli)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.cfssl pkgs.cfssl)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.digital-ocean pkgs.doctl)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.gcloud (
        pkgs.google-cloud-sdk.withExtraComponents [
          pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
          pkgs.google-cloud-sdk.components.kubectl-oidc
          pkgs.google-cloud-sdk.components.terraform-tools
          pkgs.google-cloud-sdk.components.docker-credential-gcr
        ]
      ))
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.localstack pkgs.localstack)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.argo pkgs.argo)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.argocd pkgs.argocd)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.kubectl pkgs.kubectl)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.minikube pkgs.minikube)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.kind pkgs.kind)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.helm pkgs.helm)
    ];

    programs.k9s = {
      enable = config.nixconf.packages.k9s;
      catppuccin.enable = true;
    };
  };
}
