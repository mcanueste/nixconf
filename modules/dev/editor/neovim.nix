{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    v = "nvim";
  };

  # gp-nvim = pkgs.neovimUtils.buildNeovimPlugin {
  gp-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "gp-nvim";
    version = "3.8.0";
    src = pkgs.fetchFromGitHub {
      owner = "Robitx";
      repo = "gp.nvim";
      rev = "v3.8.0";
      sha256 = "88UcYToQO3GU5Zw+EMUAP2NBpxf+b2l/PBXahrSp7fE=";
    };
    meta.homepage = "https://github.com/Robitx/gp.nvim/";
  };

  nvim-config = pkgs.vimUtils.buildVimPlugin {
    name = "config";
    src = ./nvim;
  };
in {
  options.nixconf.dev.editor = {
    neovim = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable neovim";
    };
  };

  config = lib.mkIf config.nixconf.dev.editor.neovim {
    home-manager.users.${config.nixconf.system.user} = {
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
        withNodeJs = true;
        withRuby = false;
        withPython3 = false;

        plugins = with pkgs.vimPlugins;
          [
            # Deps & UI & theme
            nui-nvim
            plenary-nvim
            nvim-web-devicons
            catppuccin-nvim
            lualine-nvim

            # No setuplsp
            vim-sleuth
            vim-tmux-navigator

            # Utilities
            mini-nvim
            oil-nvim
            telescope-nvim
            telescope-fzf-native-nvim
            git-worktree-nvim
            harpoon2
            gitsigns-nvim
            which-key-nvim
            cloak-nvim
            trouble-nvim

            FTerm-nvim
            # nvim-spectre -- TODO: check later

            # completion
            nvim-cmp
            cmp-dap
            cmp-async-path
            cmp-buffer
            cmp-cmdline
            cmp-emoji
            cmp-nvim-lsp
            cmp-nvim-lsp-signature-help
            cmp-nvim-lsp-document-symbol

            # lsp & dap
            nvim-lspconfig
            none-ls-nvim
            neodev-nvim
            rustaceanvim
            nvim-dap
            nvim-nio
            nvim-dap-ui
            nvim-dap-virtual-text
            # telescope-dap-nvim TODO useful?
            nvim-dap-go
            nvim-dap-python

            # AI
            copilot-lua
            CopilotChat-nvim

            # Note taking
            obsidian-nvim
            markview-nvim

            # treesitter
            nvim-autopairs
            nvim-ts-context-commentstring
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
                p.hcl
                p.groovy
              ]))
          ]
          ++ [gp-nvim nvim-config];

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

          # html/htmx support
          # htmx-lsp -- buggy for now

          # bash support
          nodePackages.bash-language-server
          shellharden

          # docker support
          nodePackages.dockerfile-language-server-nodejs
          hadolint

          # terraform support
          terraform-ls
          tfsec

          # python support
          ruff
          basedpyright

          # ocaml lsp
          ocamlPackages.ocaml-lsp
          ocamlPackages.ocamlformat

          # nix support
          nil
          alejandra

          # go support
          gopls
          gofumpt
          golangci-lint-langserver
          delve

          # rust support
          rust-analyzer
          rustfmt
          cargo
          lldb # debugging
          graphviz # generating graphs

          # lua support
          (luajit.withPackages (lp: [
            lp.luarocks
            lp.tiktoken_core
          ]))
          lua-language-server
          stylua

          # github actions support
          actionlint
        ];
      };
    };
  };
}
