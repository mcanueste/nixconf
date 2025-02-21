{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    ghostty = pkgs.libExt.mkEnabledOption "ghostty";
  };

  config = lib.mkIf config.nixconf.term.ghostty {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        theme = "catppuccin-mocha";
        font-size = 12;
      };
    };
  };
}
