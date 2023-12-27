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
  options.nixconf.term = {
    lazydocker = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable lazydocker";
    };
  };

  config = lib.mkIf config.nixconf.term.lazydocker {
    home-manager.users.${config.nixconf.user} = {
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};

      home.packages = [
        pkgs.lazydocker
      ];
    };
  };
}
