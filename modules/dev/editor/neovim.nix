{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    v = "nvim";
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
            # UI & theme
            nui-nvim
            plenary-nvim
            nvim-web-devicons
            catppuccin-nvim
            lualine-nvim
            # nvim-notify
            # noice-nvim
            which-key-nvim

            # tools
            vim-sleuth # no setup
            vim-tmux-navigator
            telescope-nvim
            telescope-fzf-native-nvim
            trouble-nvim
            mini-nvim
            harpoon
            FTerm-nvim
            # nvim-spectre -- TODO: check later
            cloak-nvim
            oil-nvim

            # treesitter
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
            nvim-treesitter-refactor
            nvim-treesitter-context
            nvim-ts-context-commentstring

            # git
            gitsigns-nvim
            git-worktree-nvim

            # lsp
            nvim-lspconfig
            null-ls-nvim
            neodev-nvim
            rust-tools-nvim
            SchemaStore-nvim
            symbols-outline-nvim

            # completion
            nvim-cmp
            cmp-nvim-lsp
            cmp-nvim-lua
            cmp-nvim-lsp-signature-help
            cmp-buffer
            cmp-path
            cmp-cmdline
            cmp-dap
            cmp-emoji

            # snippet
            luasnip
            cmp_luasnip
            friendly-snippets

            # debugger
            nvim-dap
            nvim-dap-ui
            nvim-dap-virtual-text
            nvim-dap-go
            nvim-dap-python
            telescope-dap-nvim

            # AI
            copilot-lua
            ChatGPT-nvim

            # Note taking
            obsidian-nvim
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

          # bash support
          beautysh
          shellharden
          shellcheck
          nodePackages.bash-language-server

          # docker support
          hadolint
          # docker-compose-language-service
          nodePackages.dockerfile-language-server-nodejs

          # terraform support
          tfsec
          terraform-ls

          # nix support
          nil
          # nixd somehow doesn't work well?
          alejandra

          # lua support
          (luajit.withPackages (lp: [
            lp.luarocks
          ]))
          lua-language-server
          stylua

          # python support
          black
          djhtml
          mypy
          ruff
          ruff-lsp
          nodePackages.pyright

          # go support
          gopls
          golangci-lint-langserver

          # ansible support
          # ansible-lint
          # ansible-language-server

          # yaml support
          # yamlfmt
          # nodePackages.yaml-language-server

          # html/htmx support
          htmx-lsp
        ];
      };
    };
  };
}
