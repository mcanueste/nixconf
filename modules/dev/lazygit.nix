{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    lg = "lazygit";
  };
in {
  options.nixconf.dev = {
    lazygit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable lazygit";
    };
  };

  config = lib.mkIf config.nixconf.dev.lazygit {
    home-manager.users.${config.nixconf.system.user} = {
      programs.bash = {inherit shellAliases;};
      programs.zsh = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};

      home.packages = [
        pkgs.lazygit
      ];
    };
  };
}
