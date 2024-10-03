{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.iac = {
    packer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable packer";
    };

    terraform = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable terraform";
    };
  };

  config = let
    shellAliases = {
      tf = "terraform";
    };
  in {
    home-manager.users.${config.nixconf.user} = {
      programs.bash = {inherit shellAliases;};
      programs.zsh = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};

      home.packages = builtins.filter (p: p != null) [
        (
          if config.nixconf.dev.iac.packer
          then pkgs.packer
          else null
        )

        (
          if config.nixconf.dev.iac.terraform
          then pkgs.terraform
          else null
        )
      ];
    };
  };
}
