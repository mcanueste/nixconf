{
  pkgs,
  config,
  ...
}: {
  environment.sessionVariables = {
    # TODO: move nixconf to ~/
    FLAKE = "/home/${config.nixconf.system.user}/Projects/personal/nixconf";
  };

  environment.systemPackages = [
    pkgs.nh
    pkgs.nvd
    pkgs.nix-output-monitor
  ];
}