{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.media = {
    obs = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable OBS";
    };
  };

  config = lib.mkIf config.nixconf.media.zathura {
    home-manager.users.${config.nixconf.user} = {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs; [
          obs-studio-plugins.wlrobs
          obs-studio-plugins.obs-vaapi
          obs-studio-plugins.obs-pipewire-audio-capture
          # obs-studio-plugins.obs-backgroundremoval
        ];
      };
    };
  };
}
