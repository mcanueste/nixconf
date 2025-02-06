{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.packages = {
    docker-compose = lib.mkEnableOption "Docker Compose";
    podman-compose = lib.mkEnableOption "Podman Compose";
    nerdctl = lib.mkEnableOption "Nerdctl";
    lazydocker = lib.mkEnableOption "Lazydocker";
    dive = lib.mkEnableOption "Dive";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.docker-compose pkgs.docker-compose)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.podman-compose pkgs.podman-compose)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.nerdctl pkgs.nerdctl)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.lazydocker pkgs.lazydocker)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.dive pkgs.dive)
    ];
  };
}
