{
  pkgs,
  config,
  ...
}: {
  config = {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.dash

        pkgs.rsync
        pkgs.gnumake
        pkgs.dig
        pkgs.traceroute
        pkgs.tree

        pkgs.entr
        pkgs.ripgrep
        pkgs.fd

        pkgs.tealdeer
        pkgs.manix

        pkgs.htop
        pkgs.ncdu
        pkgs.dive

        pkgs.hyperfine

        # pkgs.pdftk
        # pkgs.imagemagick
      ];
    };
  };
}
