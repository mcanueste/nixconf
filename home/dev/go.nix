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
    hugo = mkBoolOption {description = "Enable hugo";};
  };

  config = lib.mkIf cfg.enable {
    home.packages = filterPackages [
      pkgs.go
      (getPackageIf cfg.hugo pkgs.hugo)
    ];

    programs.bash = {
      sessionVariables = {
        GOPATH = "$HOME/.go";
      };
    };

    home.sessionVariables = {
      GOPATH = "$HOME/.go";
    };

    systemd.user.sessionVariables = {
      GOPATH = "$HOME/.go";
    };
  };
}
