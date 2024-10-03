{
  pkgs,
  config,
  ...
}: {
  environment.sessionVariables = {
    # TODO: move nixconf to ~/
    FLAKE = "/home/${config.nixconf.os.user}/Projects/personal/nixconf";
  };

  environment.systemPackages = [
    pkgs.nh
    pkgs.nvd
    pkgs.nix-output-monitor
  ];
}
