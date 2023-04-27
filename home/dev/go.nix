{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.dev.go;
in {
  options.nixhome.dev.go = {
    enable = mkBoolOption {description = "Enable go";};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.go
      pkgs.hugo
    ];

    programs.bash = {
      sessionVariables = {
        GOPATH = "~/.go";
      };
    };

    home.sessionVariables = {
      GOPATH = "~/.go";
    };

    systemd.user.sessionVariables = {
      GOPATH = "~/.go";
    };
  };
}
