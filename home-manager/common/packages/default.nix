{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./docker.nix
    ./k8s.nix
    ./cloud.nix
    ./iac.nix
    ./cicd.nix
  ];

  options.nixconf.packages = {
    todoist = lib.mkEnableOption "Todoist";
    graphite = lib.mkEnableOption "Graphite CLI";
    fabric = lib.mkEnableOption "Fabric AI ClI";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      # some must haves
      pkgs.lsof
      pkgs.lshw
      pkgs.pciutils
      pkgs.unzip
      pkgs.unrar-free
      pkgs.rsync
      pkgs.fd
      pkgs.ripgrep
      pkgs.ncdu
      pkgs.jq
      pkgs.traceroute
      pkgs.hyperfine
      pkgs.entr
      pkgs.ffmpegthumbnailer
      pkgs.just
      pkgs.fastfetch
      pkgs.bottom

      (pkgs.libExt.mkIfElseNull config.nixconf.packages.todoist pkgs.todoist)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.graphite pkgs.graphite-cli)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.fabric pkgs.fabric-ai)
    ];
  };
}
