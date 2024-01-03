{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    ld = "lazydocker";
  };
in {
  options.nixconf.tools = {
    lazydocker = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable lazydocker";
    };
  };

  config = lib.mkIf config.nixconf.tools.lazydocker {
    home-manager.users.${config.nixconf.user} = {
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};

      home.packages = [
        pkgs.lazydocker
      ];
    };
  };
}
