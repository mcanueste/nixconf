{
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    direnv = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable direnv";
    };
  };

  config = lib.mkIf config.nixconf.term.direnv {
    home-manager.users.${config.nixconf.os.user} = {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
