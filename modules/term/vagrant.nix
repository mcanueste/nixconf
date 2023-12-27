{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    vg = "vagrant";
  };
in {
  options.nixconf.term = {
    vagrant = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable vagrant";
    };
  };

  config = lib.mkIf config.nixconf.term.vagrant {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.vagrant];
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
    };
  };
}
