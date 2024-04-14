# Lazydocker: tool for managing containers on the system
#
# https://github.com/jesseduffield/lazydocker
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.iac = {
    lazydocker = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable lazydocker";
    };
  };

  config = lib.mkIf config.nixconf.dev.iac.lazydocker {
    home-manager.users.${config.nixconf.user} = {
      home.packages = [
        pkgs.lazydocker
      ];
    };
  };
}
