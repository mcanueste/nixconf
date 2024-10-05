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

  config = let
    shellAliases = {
      chat = "aichat";
    };
  in
    lib.mkIf config.nixconf.term.ai {
      programs.bash = {inherit shellAliases;};
      programs.zsh = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};

      home.packages = [
        pkgs.aichat
      ];
    };
}
