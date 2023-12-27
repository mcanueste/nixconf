{
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    zoxide = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable zoxide";
    };
  };

  config = lib.mkIf config.nixconf.term.zoxide {
    home-manager.users.${config.nixconf.user} = {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = config.nixconf.term.fish;
      };
    };
  };
}
