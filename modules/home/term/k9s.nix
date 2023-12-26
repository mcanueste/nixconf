{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    k9s = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable k9s";
    };
  };

  config = lib.mkIf config.nixconf.term.k9s {
    home.packages = [
      pkgs.k9s
    ];
    xdg.configFile."k9s/skin.yml".text = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "k9s";
        rev = "main";
        sha256 = "sha256-PtBJRBNbLkj7D2ko7ebpEjbfK9Ywjs7zbE+Y8FQVEfA=";
      }
      + "/dist/mocha.yml");
  };
}
