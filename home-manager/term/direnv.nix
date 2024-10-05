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
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
