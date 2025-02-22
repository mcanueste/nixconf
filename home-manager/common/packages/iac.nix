{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.packages = {
    cosign = lib.mkEnableOption "Cosign";
    packer = lib.mkEnableOption "Packer";
    terraform = lib.mkEnableOption "Terraform";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.cosign pkgs.cosign)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.packer pkgs.packer)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.terraform pkgs.terraform)
    ];
  };
}
