# Some tools that do not require configuration
{
  pkgs,
  config,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      coreutils-full
      curl
      wget
      lsof
      pciutils
      lshw
      libva-utils
      glxinfo
      gzip
      unzip
      cachix
    ];

    home-manager.users.${config.nixconf.system.user} = {
      home.packages = with pkgs; [
        dash
        gnumake
        rsync
        tree
        fd
        ripgrep
        htop
        ncdu
        entr
        hyperfine
        file
        ffmpegthumbnailer

        # networking tools
        dig
        traceroute

        # password managers
        bitwarden-cli
      ];
    };
  };
}
