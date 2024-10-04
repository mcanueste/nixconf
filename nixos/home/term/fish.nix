{
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    fish = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fish";
    };
  };

  config = lib.mkIf config.nixconf.term.fish {
    environment.pathsToLink = ["/share/fish"];

    home-manager.users.${config.nixconf.username} = {
      programs.fish = {
        enable = true;
        shellInit = ''
          set fish_greeting # Disable greeting
        '';
      };
    };
  };
}
