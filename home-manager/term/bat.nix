{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    bat = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable bat";
    };
  };

  config = let
    shellAliases = {
      rgb = "batgrep";
      man = "batman";
      pretty = "prettybat";
    };
  in
    lib.mkIf config.nixconf.term.bat {
      programs.bash = {inherit shellAliases;};
      programs.zsh = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};
      programs.bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batgrep
          batman
          prettybat
        ];
      };
    };
}
