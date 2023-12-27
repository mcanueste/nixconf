{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    t = "todoist";
  };
in {
  options.nixconf.term = {
    todoist = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable todoist";
    };
  };

  config = lib.mkIf config.nixconf.term.todoist {
    home-manager.users.${config.nixconf.user} = {
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
      home.packages = [
        pkgs.todoist
      ];
    };
  };
}
