{
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    eza = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable eza";
    };
  };

  config = lib.mkIf config.nixconf.term.eza {
    home-manager.users.${config.nixconf.user} = {
      programs.eza = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        git = true;
        icons = true;
      };
    };
  };
}
