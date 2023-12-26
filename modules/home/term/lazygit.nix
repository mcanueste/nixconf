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
  options.nixconf.term = {
    lazygit = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable lazygit";
    };
  };

  config = lib.mkIf config.nixconf.term.lazygit {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};

    home.packages = [
      pkgs.lazygit
    ];
  };
}
