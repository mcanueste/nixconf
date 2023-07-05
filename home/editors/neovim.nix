{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.editors.neovim;

  nvim-config = pkgs.vimUtils.buildVimPlugin {
    name = "config";
    src = ./nvim;
  };

  shellAliases = {
    v = "nvim";
  };
in {
  options.nixhome.editors.neovim = {
    enable = mkBoolOption {description = "Enable neovim configuration";};
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {inherit shellAliases;};
    programs.fish = {inherit shellAliases;};
    xdg.configFile."yamlfmt/.yamlfmt".text = ''
    formatter:
      retain_line_breaks: true
    '';

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
      withNodeJs = false;
      withRuby = false;
      withPython3 = false;

      plugins = with pkgs.vimPlugins;
        [
          # utils used by other plugins and keymaps
          nui-nvim
          plenary-nvim
          vim-tmux-navigator

          # theme
          catppuccin-nvim
          lualine-nvim
          gitsigns-nvim
          nvim-web-devicons
          which-key-nvim

          # tools
          vim-sleuth # no setup
          vim-repeat # no setup
          telescope-nvim
          trouble-nvim
          mini-nvim
          harpoon
          FTerm-nvim
          # nvim-spectre -- TODO: check later

          # languages
          (nvim-treesitter.withPlugins
            (p: [
              p.bash
              p.bibtex
              p.c
              p.cmake
              p.cpp
              p.css
              p.diff
              p.dockerfile
              p.fish
              p.git_config
              p.git_rebase
              p.gitattributes
              p.gitcommit
              p.gitignore
              p.go
              p.gomod
              p.gosum
              p.gowork
              p.graphql
              p.html
              p.htmldjango
              p.http
              p.ini
              p.javascript
              p.jq
              p.json
              p.latex
              p.lua
              p.make
              p.markdown
              p.markdown_inline
              p.meson
              p.ninja
              p.nix
              p.norg
              p.ocaml
              p.ocaml_interface
              p.ocamllex
              p.python
              p.tree-sitter-query
              p.rasi
              p.regex
              p.rst
              p.ruby
              p.rust
              p.sql
              p.svelte
              p.terraform
              p.toml
              p.tsx
              p.typescript
              p.vim
              p.vimdoc
              p.vue
              p.yaml
              p.zig
            ]))
          nvim-treesitter-context
          null-ls-nvim
          nvim-lspconfig
          luasnip
          friendly-snippets
          nvim-cmp
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp_luasnip
          rust-tools-nvim
          SchemaStore-nvim

          # extras
          # (vimPlugins.ChatGPT-nvim.overrideAttrs (old: {
          #   src = fetchFromGitHub {
          #     owner = "jackMort";
          #     repo = "ChatGPT.nvim";
          #     rev = "f499559f636676498692a2f19e74b077cbf52839";
          #     sha256 = "sha256-98daaRkdrTZyNZuQPciaeRNuzyS52bsha4yyyAALcog=";
          #   };
          # }))
          # vimPlugins.copilot-lua
        ]
        ++ [nvim-config];

      extraConfig = ''
        lua << EOF
          require('config').init()
        EOF
      '';

      extraPackages = with pkgs; [
        gcc
        stdenv
        wget
        curl
        gzip
        gnutar
        git
        xclip
        xsel
        wl-clipboard
        fd
        ripgrep
        lazygit
        lazydocker

        # nix support
        alejandra
        nil

        # lua support
        stylua
        (luajit.withPackages (lp: [
          lp.luarocks
        ]))
        lua-language-server

        # go support
        gomodifytags
        impl
        gofumpt
        gotools
        gopls
        golangci-lint-langserver

        # python support
        black
        djhtml
        mypy
        ruff
        ruff-lsp
        nodePackages.pyright

        # rust support
        rustfmt
        rust-analyzer
        graphviz

        # bash support
        beautysh
        shellharden
        shellcheck
        nodePackages.bash-language-server

        # docker support
        hadolint
        nodePackages.dockerfile-language-server-nodejs
        docker-compose-language-service

        # terraform support
        tfsec
        terraform-ls

        # ansible support
        ansible-lint
        ansible-language-server

        # yaml support
        yamlfmt
        nodePackages.yaml-language-server
      ];
    };
  };
}
