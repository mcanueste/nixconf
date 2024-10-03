# Some tools that do not require configuration
{
  pkgs,
  config,
  ...
}: {
  config = {
    home-manager.users.${config.nixconf.os.user} = {
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
        fastfetch
        jq

        # networking tools
        dig
        traceroute

        # password managers
        bitwarden-cli

        # nix specific
        manix

        # pretty markdown in term
        glow
      ];
    };
  };
}
