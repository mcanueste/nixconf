{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    v = "nvim";
  };

  trouble-beta = pkgs.vimUtils.buildVimPlugin {
    pname = "trouble.nvim";
    version = "2024-03-29";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "trouble.nvim";
      rev = "dev";
      sha256 = "pbM5W5+dIQNqoWtZDNQ1w/kMoY66YuUCH1wvASO37MM=";
    };
  };

  # TODO contribute to nixpkgs?
  telescope-picker-list = pkgs.vimUtils.buildVimPlugin {
    pname = "telescope-picker-list.nvim";
    version = "5a51890";
    src = pkgs.fetchFromGitHub {
      owner = "OliverChao";
      repo = "telescope-picker-list.nvim";
      rev = "5a5189068131a43f802721ddb07a25279d98272e";
      sha256 = "tETd3gkxB3MENSxYPnof5SP+HSBVmtxp+Wv44X4kP4Q=";
    };
  };

  # TODO contribute to nixpkgs?
  copilotchat-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "copilotchat-nvim";
    version = "2.8.1";
    src = pkgs.fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "2.8.1";
      sha256 = "jZb+dqGaZEs1h2CbvsxbINfHauwHka9t+jmSJQ/mMFM=";
    };
  };

  catppuccin-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "catppuccin-nvim";
    version = "main";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "nvim";
      rev = "main";
      sha256 = "UDPS+1o8FQGkfqiG4GX4DNUI2pU5hIvagmfnWTKDb44=";
    };
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
            # catppuccin-nvim
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

            FTerm-nvim
            # nvim-spectre -- TODO: check later

            # completion & snippets
            nvim-cmp
            cmp-dap
            cmp-async-path
            cmp-buffer
            cmp-cmdline
            cmp-emoji
            cmp-nvim-lsp
            cmp-nvim-lsp-signature-help
            cmp-nvim-lsp-document-symbol
            luasnip
            cmp_luasnip
            friendly-snippets

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
            ChatGPT-nvim

            # Note taking
            obsidian-nvim

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
              ]))
          ]
          ++ [
            nvim-config
            trouble-beta
            telescope-picker-list
            copilotchat-nvim
            catppuccin-nvim
          ];

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
          nodePackages.pyright

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
