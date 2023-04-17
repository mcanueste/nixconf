{
  pkgs,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.devops.hashicorp;
in {
  options.nixhome.devops.hashicorp = {
    terraform = mkBoolOption {description = "Enable terraform";};
    packer = mkBoolOption {description = "Enable packer";};
  };

  config = {
    home.packages = filterPackages [
      (getPackageIf cfg.terraform pkgs.terraform)
      (getPackageIf cfg.packer pkgs.packer)
    ];

    programs.bash.shellAliases = {
      tf = "terraform";
      pk = "packer";
    };

    programs.fish.shellAliases = {
      tf = "terraform";
      pk = "packer";
    };
  };
}
