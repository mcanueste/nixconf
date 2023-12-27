{
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    direnv = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable direnv";
    };
  };

  config = lib.mkIf config.nixconf.term.direnv {
    home-manager.users.${config.nixconf.user} = {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        # no need for fish integration, integrated by default
      };
    };
  };
}
