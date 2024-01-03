{
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    wezterm = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Wezterm";
    };
  };

  config = lib.mkIf config.nixconf.term.wezterm {
    home-manager.users.${config.nixconf.user} = {
      programs.wezterm = {
        enable = true;
      };
    };
  };
}
