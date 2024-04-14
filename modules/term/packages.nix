# Some term tools that do not require configuration
{
  pkgs,
  config,
  ...
}: {
  config = {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.dash
        pkgs.gnumake
        pkgs.rsync
        pkgs.tree
        pkgs.fd
        pkgs.ripgrep
        pkgs.htop
        pkgs.ncdu
        pkgs.entr
        pkgs.hyperfine

        # networking tools
        pkgs.dig
        pkgs.traceroute

        # password managers
        pkgs.bitwarden-cli
      ];
    };
  };
}
