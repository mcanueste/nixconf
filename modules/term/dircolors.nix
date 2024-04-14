{
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    dircolors = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable dircolors";
    };
  };

  config = lib.mkIf config.nixconf.term.dircolors {
    home-manager.users.${config.nixconf.user} = {
      programs.dircolors = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = config.nixconf.term.zsh;
        enableFishIntegration = config.nixconf.term.fish;
      };
    };
  };
}
