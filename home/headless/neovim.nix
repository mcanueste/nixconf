{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      " Enable mouse mode
      set mouse=a

      " Use the system clipboard
      set clipboard=unnamed

      " Use relative numbers
      set number relativenumber

      " Use a color column on the 80-character mark
      set colorcolumn=80

      " Show `▸▸` for tabs: 	, `·` for tailing whitespace:
      set list listchars=tab:▸▸,trail:·
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = rose-pine;
        config = "colorscheme rose-pine";
      }

      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''
          require('which-key').setup()
          vim.o.timeout = true
          vim.o.timeoutlen = 300
        '';
      }

      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
              -- additional_vim_regex_highlighting = { "markdown" },
            },
            indent = { enable = true },
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = '<c-space>',
                node_incremental = '<c-space>',
                scope_incremental = '<c-s>',
                node_decremental = '<c-backspace>',
              },
            },
            textobjects = {
              select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                  -- You can use the capture groups defined in textobjects.scm
                  ['aa'] = '@parameter.outer',
                  ['ia'] = '@parameter.inner',
                  ['af'] = '@function.outer',
                  ['if'] = '@function.inner',
                  ['ac'] = '@class.outer',
                  ['ic'] = '@class.inner',
                },
              },
              move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                  [']m'] = '@function.outer',
                  [']]'] = '@class.outer',
                },
                goto_next_end = {
                  [']M'] = '@function.outer',
                  [']['] = '@class.outer',
                },
                goto_previous_start = {
                  ['[m'] = '@function.outer',
                  ['[['] = '@class.outer',
                },
                goto_previous_end = {
                  ['[M'] = '@function.outer',
                  ['[]'] = '@class.outer',
                },
              },
              swap = {
                enable = true,
                swap_next = {
                  ['<leader>a'] = '@parameter.inner',
                },
                swap_previous = {
                  ['<leader>A'] = '@parameter.inner',
                },
              },
            },
          }
        '';
      }

      plenary-nvim
      telescope-fzf-writer-nvim
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          vim.g.mapleader = ' '
          vim.g.maplocalleader = ' '

          require('telescope').setup {
            extensions = {
              fzf_writer = {
                minimum_grep_characters = 2,
                minimum_files_characters = 2,
                use_highlighter = true,
              }
            }
          }
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
          vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        '';
      }
    ];
  };
}
