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
  options.nixconf.tools = {
    vagrant = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable vagrant";
    };
  };

  config = lib.mkIf config.nixconf.tools.vagrant {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [pkgs.vagrant];
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
    };
  };
}
