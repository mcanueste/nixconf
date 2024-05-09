{
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    eza = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable eza";
    };
  };

  config = lib.mkIf config.nixconf.term.eza {
    home-manager.users.${config.nixconf.system.user} = {
      programs.eza = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
        git = true;
        icons = true;
      };
    };
  };
}
