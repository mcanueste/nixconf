{
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    dircolors = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable dircolors";
    };
  };

  config = lib.mkIf config.nixconf.term.dircolors {
    programs.dircolors = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = config.nixconf.term.fish;
    };
  };
}
