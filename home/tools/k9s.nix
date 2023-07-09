{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.tools;
in {
  options.nixhome.tools = {
    k9s = mkBoolOption {description = "Enable k9s";};
  };

  config = lib.mkIf cfg.k9s {
    home.packages = [
      pkgs.k9s
    ];
    xdg.configFile."k9s/skin.yml".text = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "k9s";
        rev = "main";
        sha256 = "sha256-GrRCOwCgM8BFhY8TzO3/WDTUnGtqkhvlDWE//ox2GxI=";
      }
      + "/dist/mocha.yml");
  };
}
