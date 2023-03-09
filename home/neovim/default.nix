{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixhome.neovim;
in {
  options.nixhome.neovim = {
    enable = lib.mkOption {
      description = "Enable neovim configuration";
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."nvim/" = {
      source = ./nvim;
      recursive = true;
    };

    home.file.".vale.ini" = {
      source = ./vale.ini;
    };

    home.packages = with pkgs; [
      neovim
      gcc
      stdenv
      xclip
      xsel
      wl-clipboard
      git
      ripgrep
      fd
      wget
      curl
      gzip
      gnutar
      lazygit

      # generic formatting
      nodePackages.prettier

      # markdown
      proselint
      vale
      marksman

      # toml support
      taplo

      # yaml
      yamllint
      nodePackages.yaml-language-server

      # docker support
      hadolint
      nodePackages.dockerfile-language-server-nodejs

      # ansible
      ansible-lint
      ansible-language-server

      # terraform support
      tfsec
      terraform-ls

      # bash support
      beautysh
      shellcheck
      shellharden
      nodePackages.bash-language-server

      # go support
      go
      gopls
      gofumpt
      gotools
      golines
      golangci-lint

      # rust support
      cargo
      rustc
      rustfmt
      rust-analyzer

      # lua support
      (luajit.withPackages (lp: [
        lp.luarocks
      ]))
      lua-language-server

      # javascript support
      nodejs
      nodePackages.npm
      nodePackages.neovim

      # pyright support
      (python311.withPackages (pp: [
        pp.pip
        pp.pynvim
        pp.black
        pp.mypy
      ]))
      ruff
      nodePackages.pyright

      # nix support
      alejandra
      statix
      nil
    ];

    programs.bash = {
      shellAliases = {
        v = "nvim";
        vc = "XDG_CONFIG_HOME=~/nix/nixos/home/neovim/ nvim";
      };
    };
  };
}
