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
    home-manager.users.${config.nixconf.user} = {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting # Disable greeting
        '';
      };
    };
  };
}
