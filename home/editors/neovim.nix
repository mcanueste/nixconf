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

  capture-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "capture-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "mcanueste";
      repo = "capture.nvim";
      rev = "ea4ed03278a405439dac0fe9b1aed28b43124e37";
      sha256 = "sha256-tsI/D6O5nUWLHgtXtX8iPaiSb6MRx1d4uLKYf1onGh4=";
    };
  };

  vim-just = pkgs.vimUtils.buildVimPlugin {
    name = "vim-just";
    src = pkgs.fetchFromGitHub {
      owner = "NoahTheDuke";
      repo = "vim-just";
      rev = "10de9ebf0bd8df8ff8593b0b87ec8bf3b715326f";
      sha256 = "sha256-NGhWF4/SEPww9e/wCDghGMSPZmmAbms6tn/IHqDMDkI=";
    };
  };

  shellAliases = {
    v = "nvim";
  };
in {
  options.nixhome.editors.neovim = {
    enable = mkBoolOption {description = "Enable neovim configuration";};
  };

  # TODO: git-worktree plugin
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
        ++ [nvim-config capture-nvim vim-just];

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
        docker-compose-language-service
        nodePackages.dockerfile-language-server-nodejs

        # terraform support
        tfsec
        terraform-ls

        # nix support
        # TODO: comments don't work properly
        alejandra
        nil

        # lua support : works well
        stylua
        (luajit.withPackages (lp: [
          lp.luarocks
        ]))
        lua-language-server

        # python support
        black
        djhtml
        mypy
        ruff
        ruff-lsp
        nodePackages.pyright

        # go support
        gomodifytags
        impl
        gofumpt
        gotools
        gopls
        golangci-lint-langserver

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
