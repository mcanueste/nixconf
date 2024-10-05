{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    yazi = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable yazi";
    };
  };

  config = lib.mkIf config.nixconf.term.yazi {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      keymap = {};
      settings = {};
    };
  };
}
