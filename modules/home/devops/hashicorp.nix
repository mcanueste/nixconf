{
  pkgs,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.devops.hashicorp;
in {
  options.nixhome.devops.hashicorp = {
    vagrant = mkBoolOption {description = "Enable vagrant";};
    packer = mkBoolOption {description = "Enable packer";};
    terraform = mkBoolOption {description = "Enable terraform";};
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.vagrant pkgs.vagrant)
      (getPackageIf cfg.packer pkgs.packer)
      (getPackageIf cfg.terraform pkgs.terraform)
    ];

    programs.bash.shellAliases = {
      vg = "vagrant";
      pk = "packer";
      tf = "terraform";
    };

    programs.fish.shellAliases = {
      vg = "vagrant";
      pk = "packer";
      tf = "terraform";
    };
  };
}
