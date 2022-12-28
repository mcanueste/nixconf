{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = false;
    enableFishIntegration = true;
    settings = {
      scan_timeout = 10;
      # TODO: remove formatters not used
      # format = lib.concatStrings [
      # ];
    };
  };
}
