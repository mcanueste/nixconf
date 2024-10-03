{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    ai = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable terminal AI tools";
    };
  };

  config = lib.mkIf config.nixconf.term.ai {
    home-manager.users.${config.nixconf.username} = let
      shellAliases = {
        chat = "aichat";
      };
    in {
      programs.bash = {inherit shellAliases;};
      programs.zsh = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};

      home.packages = [
        pkgs.aichat
      ];
    };
  };
}
