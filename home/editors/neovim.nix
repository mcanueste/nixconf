{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.editors.neovim;
in {
  options.nixhome.editors.neovim = {
    enable = mkBoolOption {description = "Enable neovim configuration";};
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."nvim/" = {
      source = ./nvim;
      recursive = true;
    };

    programs.bash = {
      shellAliases = {
        v = "nvim";
        vconf = "XDG_CONFIG_HOME=$HOME/nix/nixconf/home/editors/ nvim ~/nix/nixconf/home/editors/neovim.nix";
      };
      sessionVariables = {
        EDITOR = "nvim";
      };
    };

    programs.fish = {
      shellAliases = {
        v = "nvim";
        vconf = "XDG_CONFIG_HOME=$HOME/nix/nixconf/home/editors/ nvim ~/nix/nixconf/home/editors/neovim.nix";
      };
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    systemd.user.sessionVariables = {
      EDITOR = "nvim";
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
      # nodePackages.prettier

      # markdown
      # proselint
      # marksman

      # toml support
      # taplo

      # yaml
      # yamllint
      # nodePackages.yaml-language-server

      # docker support
      # hadolint
      # nodePackages.dockerfile-language-server-nodejs

      # ansible
      # ansible-lint
      # ansible-language-server

      # terraform support
      # tfsec
      # terraform-ls

      # bash support
      # beautysh
      # shellcheck
      # shellharden
      # nodePackages.bash-language-server

      # go support
      go
      gofumpt # formatter
      golines # formatter
      golangci-lint # linter
      gotools # linter: staticcheck + other tools?
      gomodifytags # code action
      impl # code action
      gopls # lsp

      # rust support
      # cargo
      # rustc
      # rustfmt
      # rust-analyzer

      # lua support
      stylua
      (luajit.withPackages (lp: [
        lp.luarocks
      ]))
      lua-language-server

      # javascript support
      # nodejs
      # nodePackages.npm
      # nodePackages.neovim

      # pyright support
      # (python311.withPackages (pp: [
      #   pp.pip
      #   pp.pynvim
      #   pp.black
      #   pp.mypy
      # ]))
      # ruff
      # nodePackages.pyright

      # nix support
      alejandra
      statix
      nil
    ];
  };
}
