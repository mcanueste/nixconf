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
  options.nixconf.tools = {
    todoist = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable todoist";
    };
  };

  config = lib.mkIf config.nixconf.tools.todoist {
    home-manager.users.${config.nixconf.user} = {
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
      home.packages = [
        pkgs.todoist
      ];
    };
  };
}
