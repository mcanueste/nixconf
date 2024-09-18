{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.languages = {
    just = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Just";
    };

    pre-commit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable pre-commit";
    };

    python = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable python";
    };

    rust = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable rust";
    };

    go = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable go";
    };
  };

  config = let
    pythonPackages =
      if config.nixconf.dev.languages.python
      then [
        pkgs.uv
        pkgs.ruff
        pkgs.pixi
      ]
      else [];

    rustPackages =
      if config.nixconf.dev.languages.rust
      then [
        # pkgs.rustup
        # pkgs.cargo
        # pkgs.rustfmt
      ]
      else [];

    goPackages =
      if config.nixconf.dev.languages.go
      then [
        pkgs.go
        pkgs.golangci-lint
      ]
      else [];
  in {
    home-manager.users.${config.nixconf.system.user} = {
      home.packages =
        builtins.filter (p: p != null) [
          (
            if config.nixconf.dev.languages.just
            then pkgs.just
            else null
          )

          (
            if config.nixconf.dev.languages.pre-commit
            then pkgs.pre-commit
            else null
          )

          (
            if config.nixconf.dev.languages.python
            then pkgs.pre-commit
            else null
          )
        ]
        ++ pythonPackages
        ++ rustPackages
        ++ goPackages;
    };
  };
}
