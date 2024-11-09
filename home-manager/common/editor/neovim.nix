{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  options.nixconf.editor.neovim = pkgs.libExt.mkEnabledOption "neovim";

  config = lib.mkIf config.nixconf.editor.neovim {
    programs = let
      shellAliases = {
        v = "nvim";
      };
    in {
      bash = {inherit shellAliases;};
      fish = {inherit shellAliases;};
      nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        performance = {
          byteCompileLua = {
            enable = true;
            nvimRuntime = true;
            plugins = true;
          };
        };

        globals = {
          mapleader = " ";
          maplocalleader = "\\";
          markdown_recommended_style = 0; # Fix markdown indentation settings
        };

        opts = {
          sessionoptions = ["buffers" "curdir" "tabpages" "winsize"];
          inccommand = "nosplit"; # preview incremental substitute
          autowrite = true; # Enable auto write

          grepformat = "%f:%l:%c:%m"; # Formatting of :grep
          grepprg = "rg --vimgrep"; # :grep command to use

          expandtab = true; # Use spaces instead of tabs
          shiftround = true; # Round indent
          shiftwidth = 2; # Size of an indent
          tabstop = 2; # Number of spaces tabs count for
          relativenumber = true; # Relative line numbers

          sidescrolloff = 8; # Columns of context
          scrolloff = 10; # Rows of context
          conceallevel = 1;

          list = false; # hide listchars

          spell = false; # disable by default
          spelllang = ["en"];

          timeout = true;
          timeoutlen = 500;

          undolevels = 10000; # keep longer undo history
          swapfile = false; # don't use swapfiles

          wildmode = "longest:full,full"; # Command-line completion mode

          formatoptions = "jql1tcron";
        };

        autoGroups = {
          checkTime.clear = true;
          resizeSplits.clear = true;
          lastLoc.clear = true;
          wrapSpell.clear = true;
          closeWithQ.clear = true;
          lastMod.clear = true;
        };

        autoCmd = [
          {
            desc = "Reload the buffer if it has changed";
            group = "checkTime";
            event = ["FocusGained" "TermClose" "TermLeave"];
            command = "checktime";
          }

          {
            desc = "Resize splits if window got resized";
            group = "resizeSplits";
            event = "VimResized";
            callback.__raw = ''
              function()
                vim.cmd("tabdo wincmd =")
              end
            '';
          }

          {
            desc = "Go to last loc when opening a buffer";
            group = "lastLoc";
            event = "BufReadPost";
            callback.__raw = ''
              function()
                local mark = vim.api.nvim_buf_get_mark(0, '"')
                local lcount = vim.api.nvim_buf_line_count(0)
                if mark[1] > 0 and mark[1] <= lcount then
                  pcall(vim.api.nvim_win_set_cursor, 0, mark)
                end
              end
            '';
          }

          {
            desc = "Wrap and check for spell in text file types";
            group = "wrapSpell";
            event = "FileType";
            pattern = ["gitcommit" "markdown"];
            callback.__raw = ''
              function()
                vim.opt_local.wrap = true
                vim.opt_local.spell = true
              end
            '';
          }

          {
            desc = "Close listed filetypes with `q`";
            group = "closeWithQ";
            event = "FileType";
            pattern = ["help" "man"];
            callback.__raw = ''
              function(event)
                vim.bo[event.buf].buflisted = false
                vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
              end
            '';
          }

          {
            desc = "Update `lastmod` in markdown files";
            group = "lastMod";
            event = "BufWritePre";
            pattern = "*.md";
            callback.__raw = ''
              function()
                local bufnr = vim.api.nvim_get_current_buf()
                for line_num = 0, vim.api.nvim_buf_line_count(bufnr) - 1 do
                  local line = vim.api.nvim_buf_get_lines(bufnr, line_num, line_num + 1, false)[1]
                  if line:match 'lastmod:' then
                    local new_date = os.date 'lastmod: %Y-%m-%d'
                    vim.api.nvim_buf_set_lines(bufnr, line_num, line_num + 1, false, { tostring(new_date) })
                    break
                  end
                end
              end
            '';
          }
        ];

        extraConfigLuaPre = ''
          vim.opt.isfname:append("@-@") -- Filename for gf and other file commands
        '';

        keymaps = let
          map = mode: key: action: desc: {
            inherit mode key action;
            options.desc = desc;
          };
        in [
          # Clear search with ESC
          (map ["n" "i"] "<esc>" "<cmd>noh<cr><esc>" "Clear Search")

          # Cut/Paste without saving to register
          (map ["v"] "<leader>ep" "[[\"_dP]]" "Paste w/o register")
          (map ["n"] "<leader>ed" "[[viw\"_d]]" "Delete word w/o register")
          (map ["v"] "<leader>ed" "[[\"_d]]" "Delete w/o register")

          # Move to the beginning or end of line with H and L
          (map ["n" "v"] "H" "^" "Move beginning of line")
          (map ["n"] "L" "$" "Move end of line")
          (map ["v"] "L" "g_" "Move end of line")

          # Center cursor after jumps
          (map ["n"] "<C-d>" "<C-d>zz" "Center cursor after jump")
          (map ["n"] "<C-u>" "<C-u>zz" "Center cursor after jump")
          (map ["n"] "n" "nzzzv" "Center cursor after jump")
          (map ["n"] "N" "Nzzzv" "Center cursor after jump")

          # Add conceallevel toggle
          (
            map ["n"] "<leader>tu" ''
              function()
                local winnr = vim.api.nvim_get_current_win()
                local conceallevel = vim.api.nvim_win_get_option(winnr, "conceallevel")
                local newconceallevel = math.fmod(conceallevel + 1, 4)
                vim.opt.conceallevel = newconceallevel
              end
            '' "Toggle 'conceallevel'"
          )
        ];

        clipboard = {
          register = "unnamedplus"; # sync with system clipboard `vim.g.clipboard = "unnamedplus",`
          providers = {
            wl-copy.enable = true;
            xclip.enable = true;
            xsel.enable = true;
          };
        };

        colorschemes.catppuccin = {
          enable = true;
          settings = {
            flavour = "mocha";
            integrations = {
              diffview = true;
              blink_cmp = true;
              which_key = true;
              lsp_trouble = true;
              mini.indentscope_color = "lavender";
            };
          };
        };

        plugins = {
          lualine.enable = true;

          mini = {
            enable = true;
            mockDevIcons = true;
            modules = {
              ai = {};
              bufremove = {};
              comment = {};
              diff = {};
              icons = {};
              move = {};
              surround = {};
              indentscope.symbol = "│";
              splitjoin.mappings.toggle = "<leader>es";
              bracketed = {
                buffer.suffix = "b";
                comment.suffix = "c";
                conflict.suffix = "x";
                diagnostic.suffix = "d";
                jump.suffix = "j";
                indent.suffix = ""; # using indentscope instead
                location.suffix = ""; # using trouble instead
                quickfix.suffix = ""; # using trouble instead
                file.suffix = ""; # not using
                oldfile.suffix = ""; # not using
                treesitter.suffix = ""; # not using
                undo.suffix = ""; # not using
                window.suffix = ""; # not using
                yank.suffix = ""; # not using
              };
              basics = {
                options = {
                  extra_ui = true;
                  win_borders = "bold";
                };
                mappings = {
                  option_toggle_prefix = "<leader>t";
                  windows = true;
                };
              };
            };
            luaConfig.post = ''
              -- delete mini.basics binding for sys clipboard yank and paste (using global clipboard)
              vim.keymap.del({ "n", "x" }, "gy")
              vim.keymap.del({ "n", "x" }, "gp")
            '';
          };

          tmux-navigator.enable = true;

          diffview = {
            enable = true;
            enhancedDiffHl = true;
            # NOTE: luaConfig.post is not enabled for this plugin so putting it after autopairs below
          };

          nvim-autopairs = {
            enable = true;
            settings.disable_filetype = ["TelescopePrompt"];
            luaConfig.post = ''
              local function map(l, r, desc) vim.keymap.set("n", l, r, { desc = desc }) end
              local function mapv(l, r, desc) vim.keymap.set("v", l, r, { desc = desc }) end

              map("<leader>go", "<cmd>DiffviewOpen<cr>", "Diffview Open")
              map("<leader>gc", "<cmd>DiffviewClose<cr>", "Diffview Close")
              map("<leader>gr", "<cmd>DiffviewRefresh<cr>", "Diffview Refresh")
              map("<leader>gt", "<cmd>DiffviewToggleFiles<cr>", "Diffview Toggle Files")
              map("<leader>gF", "<cmd>DiffviewFocusFiles<cr>", "Diffview Focus Files")
              map("<leader>gf", "<cmd>DiffviewFileHistory<cr>", "Diffview File History")
              mapv("<leader>gf", "<cmd>'<,'>DiffviewFileHistory<cr>", "Diffview File History")
            '';
          };

          arrow = {
            enable = true;
            settings = {
              show_icons = true;
              index_keys = "asdfgqwert";
              leader_key = "<leader>h";
              buffer_leader_key = "<leader>m";
              mappings = {
                quit = "esc";
                toggle = "h";
                edit = "z";
                remove = "x";
                delete_mode = "X";
                clear_all_items = "C";
                open_vertical = "v";
                open_horizontal = "S";
                next_item = "]";
                prev_item = "[";
              };
            };
          };

          oil = {
            enable = true;
            settings = {
              delete_to_trash = true;
              skip_confirm_for_simple_edits = false;
              view_options.show_hidden = true;
              columns = [
                "icon"
                "permissions"
                "size"
                "mtime"
              ];
              use_default_keymaps = false;
              keymaps = {
                "<CR>" = "actions.select";
                "-" = "actions.parent";
                "_" = "actions.open_cwd";
                "`" = "actions.cd";
                "~" = "actions.tcd";
                "<leader>b?" = "actions.show_help";
                "<leader>bv" = "actions.select_vsplit";
                "<leader>bs" = "actions.select_split";
                "<leader>bp" = "actions.preview";
                "<leader>bq" = "actions.close";
                "<leader>br" = "actions.refresh";
                "<leader>bS" = "actions.change_sort";
                "<leader>bo" = "actions.open_external";
                "<leader>bh" = "actions.toggle_hidden";
                "<leader>bt" = "actions.toggle_trash";
              };
            };
            luaConfig.post = ''
              vim.keymap.set("n", "<leader>oe", "<cmd>Oil<cr>", { desc = "Explorer" })
            '';
          };

          telescope = {
            enable = true;
            settings.defaults.file_ignore_patterns = [
              "^.git/"
              "^node_modules/"
              "^env/"
              "^.venv/"
              "^.direnv/"
              "^__pycache__/"
              "^.mypy_cache/"
            ];
            extensions = {
              manix.enable = true;
              ui-select.enable = true;
              fzf-native = {
                enable = true;
                settings = {
                  case_mode = "smart_case";
                  fuzzy = true;
                  override_file_sorter = true;
                  override_generic_sorter = true;
                };
              };
            };
            luaConfig.post = ''
              local function git_root()
                local root = string.gsub(vim.fn.system "git rev-parse --show-toplevel", "\n", "")
                if vim.v.shell_error == 0 then
                  return root
                end
                return nil
              end

              local function run_cmd_in_cwd(func, cwd)
                local builtin = require "telescope.builtin"
                local utils = require "telescope.utils"
                if cwd then
                  builtin[func] { cwd = utils.buffer_dir() }
                else
                  builtin[func] { cwd = git_root() }
                end
              end

              local function map(l, r, desc)
                vim.keymap.set("n", l, r, { desc = desc })
              end

              -- Find keymaps that can be run in git root
              map("<leader>ff", function() run_cmd_in_cwd('find_files', false) end, "Find Files")
              map("<leader>fF", function() run_cmd_in_cwd('find_files', true) end, "Find Files (cwd)")
              map("<leader>fg", function() run_cmd_in_cwd('live_grep', false) end, "Grep Files")
              map("<leader>fG", function() run_cmd_in_cwd('live_grep', true) end, "Grep Files (cwd)")
              map("<leader>fh", function() run_cmd_in_cwd('grep_string', false) end, "Grep Current Word")
              map("<leader>fH", function() run_cmd_in_cwd('grep_string', true) end, "Grep Current Word (cwd)")
            '';
            keymaps = let
              map = action: desc: {
                inherit action;
                options.desc = desc;
              };
            in {
              "<leader><leader>" = map "resume" "Telescope Resume";

              # Find Keymaps
              "<leader>fb" = map "buffers" "Buffers";
              "<leader>fc" = map "command_history" "Command History";
              "<leader>fm" = map "marks" "Marks";
              "<leader>fr" = map "registers" "Registers";

              # Search Keymaps
              "<leader>fsk" = map "keymaps" "Keymaps";
              "<leader>fsa" = map "autocommands" "Autocommands";
              "<leader>fsc" = map "commands" "Commands";
              "<leader>fso" = map "vim_options" "Options";
              "<leader>fsf" = map "filetypes" "Filetypes";
              "<leader>fsh" = map "help_tags" "Help Tags";
              "<leader>fsH" = map "highlights" "Highlight Groups";
              "<leader>fsm" = map "manix" "Manix";
              "<leader>fsM" = map "man_pages" "Man Pages";
            };
          };

          treesitter = {
            enable = true;
            folding = true; # disable folding by default
            luaConfig.post = ''
              vim.opt.foldmethod = "expr"
              vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
              vim.opt.foldenable = false -- disable folds by default
            '';
          };

          treesitter-context = {
            enable = true;
            settings = {
              max_lines = 4;
              multiline_threshold = 4;
            };
          };

          blink-cmp = {
            enable = true;
            settings = {
              keymap = {
                "<C-space>" = ["show" "show_documentation" "hide_documentation"];
                "<C-e>" = ["hide"];
                "<CR>" = ["accept" "fallback"];
                "<Tab>" = ["snippet_forward" "fallback"];
                "<S-Tab>" = ["snippet_backward" "fallback"];
                "<Up>" = ["select_prev" "fallback"];
                "<Down>" = ["select_next" "fallback"];
                "<C-p>" = ["select_prev" "fallback"];
                "<C-n>" = ["select_next" "fallback"];
                "<C-b>" = ["scroll_documentation_up" "fallback"];
                "<C-f>" = ["scroll_documentation_down" "fallback"];
              };
              nerd_font_variant = "mono";
              accept.auto_brackets.enabled = true;
              documentation.auto_show = true;
              highlight.use_nvim_cmp_as_default = true;
              trigger.signature_help.enabled = true;
            };
          };

          friendly-snippets.enable = true;

          trouble = {
            enable = true;
            luaConfig.post = let
              qfFunc = desc: key: action: ''
                vim.keymap.set('n', '${key}', function()
                  local tr = package.loaded.trouble
                  if tr.is_open() then
                    tr.${action} { skip_groups = true, jump = true }
                  else
                    vim.cmd.c${action}()
                  end
                end, { desc = 'Trouble ${desc}' })
              '';
              map = desc: key: action: "vim.keymap.set('n', '${key}', '${action}', { desc = '${desc}' })";
            in ''
              ${qfFunc "Prev" "[q" "prev"}
              ${qfFunc "Next" "]q" "next"}
              ${map "Buffer Diagnostics" "<leader>ld" "<cmd>Trouble diagnostics toggle filter.buf=0<cr>"}
              ${map "Workspace Diagnostics" "<leader>lD" "<cmd>Trouble diagnostics toggle<cr>"}
              ${map "Quickfix List" "<leader>lq" "<cmd>Trouble qflist toggle<cr>"}
              ${map "Symbols" "<leader>ls" "<cmd>Trouble symbols toggle focus=false<cr>"}
              ${map "Definitions/References/..." "<leader>lg" "<cmd>Trouble lsp toggle focus=false win.position=right<cr>"}
            '';
          };

          todo-comments = {
            enable = true;
            keymaps.todoTrouble.key = "<leader>lt";
          };

          lsp = {
            enable = true;
            inlayHints = true;
            capabilities = ''
              -- Note: this function is called during LSP lua setup inside a function defining the default
              -- `capabilities`, and returning it.
              -- See https://github.com/nix-community/nixvim/blob/898246c943ba545a79d585093e97476ceb31f872/plugins/lsp/default.nix#L240C13-L240C71
              capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
            '';
            preConfig = ''
              -- Change diagnostic symbols in the sign column (gutter)
              local signs = { Error = '', Warn = '', Hint = '', Info = '' }
              for type, icon in pairs(signs) do
                local hl = 'DiagnosticSign' .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
              end
            '';
            # FIX: doesn't work?
            onAttach = ''
              if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                local highlight_augroup = vim.api.nvim_create_augroup('userLspHighlight', { clear = false })

                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                  buffer = bufnr,
                  group = highlight_augroup,
                  callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                  buffer = bufnr,
                  group = highlight_augroup,
                  callback = vim.lsp.buf.clear_references,
                })

                vim.api.nvim_create_autocmd('LspDetach', {
                  group = vim.api.nvim_create_augroup('userLspDetach', { clear = true }),
                  callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'userLspHighlight', buffer = event2.buf }
                  end,
                })
              end
            '';
            keymaps = {
              extra = let
                map = mode: key: action: desc: {
                  inherit mode key action;
                  options.desc = desc;
                };
              in [
                (map ["n"] "K" "vim.lsp.buf.hover" "Hover")
                (map ["n"] "gk" "vim.lsp.buf.signature_help" "Signature")
                (map ["n"] "gl" "vim.diagnostic.open_float" "Line Diagnostics")
                (map ["n" "v"] "ga" "vim.lsp.buf.code_action" "Code Action")
                (map ["n"] "gd" "vim.lsp.buf.definition" "Definition")
                (map ["n"] "gD" "vim.lsp.buf.declaration" "Declaration")
                (map ["n"] "gi" "vim.lsp.buf.implementation" "Implementation")
                (map ["n"] "gy" "vim.lsp.buf.type_definition" "Type Definition")
                (map ["n"] "gr" "vim.lsp.buf.references" "References")
                (map ["n"] "gR" "vim.lsp.buf.rename" "Rename")
                (map ["n"] "<leader>li" "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end" "Toggle Inlay Hints")
              ];
            };
            servers = {
              bashls = {
                enable = true;
                settings.bashIde.globPattern = "*@(.sh|.inc|.bash|.command)";
              };
              dockerls = {
                enable = true;
                settings.docker.languageserver.formatter.ignoreMultilineInstructions = true;
              };
              terraformls.enable = true;
              lua_ls = {
                enable = true;
                settings = {
                  telemetry.enable = false;
                  format.enable = false;
                  completion.callSnippet = "Replace";
                  diagnostics.disable = ["missing-fields"];
                };
                # FIX: setup for neovim dev?
              };
              golangci_lint_ls.enable = true;
              gopls = {
                enable = true;
                settings.gopls.usePlaceholders = true;
              };
              ruff.enable = true;
              pyright = {
                enable = true;
                settings.pyright.analysis = {
                  autoSearchPaths = true;
                  diagnosticMode = "openFilesOnly";
                  useLibraryCodeForTypes = true;
                };
              };
              nixd = {
                enable = true;
                settings = {
                  formatting.command = ["alejandra"];
                  nixpkgs.expr = "import (builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").inputs.nixpkgs { }";
                  options = {
                    nixos.expr = "(builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").nixosConfigurations.nixos.options";
                    home-manager.expr = "(builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").homeConfigurations.\"${config.nixconf.username}@nixos\".options";
                  };
                };
              };
            };
          };

          rustaceanvim = {
            enable = true;
            settings = {
              server.default_settings = {
                rust-analyzer = {
                  check.command = "clippy";
                  inlayHints.lifetimeElisionHints.enable = "always";
                };
              };
              tools = {
                enable_clippy = true;
                enable_nextest = true;
              };
              dap.autoload_configurations = true;
            };
          };

          typescript-tools.enable = true;

          conform-nvim = {
            enable = true;
            settings = {
              default_format_opts.lsp_format = "fallback";
              format_on_save.lsp_format = "fallback";
              formatters = {
                shellcheck.command = lib.getExe pkgs.shellcheck;
                shfmt.command = lib.getExe pkgs.shfmt;
                shellharden.command = lib.getExe pkgs.shellharden;
                stylue.command = lib.getExe pkgs.stylua;
                clang_format.command = lib.getExe' pkgs.clang-tools "clang-format";
                gofumpt.command = lib.getExe pkgs.gofumpt;
                goimports.command = lib.getExe' pkgs.gotools "goimports";
                prettier.command = lib.getExe pkgs.nodePackages.prettier;
                prettierd.command = lib.getExe pkgs.prettierd;
                alejandra.command = lib.getExe pkgs.alejandra;
                squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
              };
              formatters_by_ft = {
                bash = ["shellcheck" "shellharden" "shfmt"];
                lua = ["stylua"];
                cpp = ["clang_format"];
                go = ["gofumpt" "goimports"];
                python = ["ruff_format" "ruff_organize_imports" "ruff_fix"];
                javascript = {
                  __unkeyed-1 = "prettierd";
                  __unkeyed-2 = "prettier";
                  timeout_ms = 2000;
                  stop_after_first = true;
                };
                nix = ["alejandra"];
                "_" = ["squeeze_blanks" "trim_whitespace" "trim_newlines"];
              };
            };
          };

          # TODO: nvim-lint

          dap = {
            enable = true;
            extensions = {
              dap-ui = {
                enable = true;
                icons = {
                  expanded = "▾";
                  collapsed = "▸";
                  current_frame = "*";
                };
                controls = {
                  icons = {
                    pause = "⏸";
                    play = "▶";
                    step_into = "⏎";
                    step_over = "⏭";
                    step_out = "⏮";
                    step_back = "b";
                    run_last = "▶▶";
                    terminate = "⏹";
                    disconnect = "⏏";
                  };
                };
              };
              dap-virtual-text.enable = true;
              dap-go.enable = true;
              dap-python.enable = true;
            };
            # Bug?
            # signs = let
            #   map = icon: color: {
            #     text = icon;
            #     texthl = color;
            #     numhl = color;
            #   };
            # in {
            #   dapBreakpoint = map "" "#e51400";
            #   dapBreakpointCondition = map "" "#e51400";
            #   dapBreakpointRejected = map "" "#e51400";
            #   dapLogPoint = map "" "#e51400";
            #   dapStopped = map "" "#ffcc00";
            # };
            # FIX: no lua config?
            # local dap = require 'dap'
            # local dapui = require 'dapui'
            # return {
            #   -- Basic debugging keymaps, feel free to change to your liking!
            #   { '<leader>dc', dap.continue, desc = 'Debug: Start/Continue' },
            #   { '<leader>di', dap.step_into, desc = 'Debug: Step Into' },
            #   { '<leader>do', dap.step_over, desc = 'Debug: Step Over' },
            #   { '<leader>dO', dap.step_out, desc = 'Debug: Step Out' },
            #   { '<leader>db', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
            #   {
            #     '<leader>dB',
            #     function()
            #       dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
            #     end,
            #     desc = 'Debug: Set Breakpoint',
            #   },
            #   -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
            #   { '<leader>dl', dapui.toggle, desc = 'Debug: See last session result.' },
            #   unpack(keys),
            # }
          };

          copilot-lua = {
            enable = true;
            panel = {
              enabled = true;
              autoRefresh = false;
              keymap = {
                refresh = "<C-r>";
                open = "<C-CR>";
              };
            };
            suggestion = {
              enabled = true;
              autoTrigger = true;
              keymap = {
                accept = "<C-l>";
                dismiss = "<C-h>";
                next = "<C-j>";
                prev = "<C-k>";
              };
            };
          };

          copilot-chat = {
            enable = true;
            settings = {
              debug = true;
              model = "gpt-4";
              temperature = 0.1;
              context = "buffers"; # Default context: "buffers" | "buffer" | nil
            };
            luaConfig.post = ''
              local function map(l, r, desc)
                vim.keymap.set("n", l, r, { desc = desc })
              end

              map('<leader>cc', ':CopilotChatToggle<cr>', 'Toggle Chat')
              map('<leader>cS', ':CopilotChatStop<cr>', 'Stop Output')
              map('<leader>cR', ':CopilotChatReset<cr>', 'Reset Chat')
              map('<leader>cM', ':CopilotChatModels<cr>', 'Models')
              map('<leader>ce', ':CopilotChatExplain<cr>', 'Explain')
              map('<leader>ce', ':CopilotChatReview<cr>', 'Review')
              map('<leader>cf', ':CopilotChatFix<cr>', 'Fix')
              map('<leader>co', ':CopilotChatOptimize<cr>', 'Optimize')
              map('<leader>cd', ':CopilotChatDocs<cr>', 'Docs')
              map('<leader>ct', ':CopilotChatTests<cr>', 'Tests')
              map('<leader>ci', ':CopilotChatFixDiagnostic<cr>', 'Fix Diagnostic')
              map('<leader>cm', ':CopilotChatCommit<cr>', 'Commit Message')
              map('<leader>cs', ':CopilotChatCommitStaged<cr>', 'Commit Message (Staged)')
            '';
          };

          which-key = {
            enable = true;
            settings.spec = let
              map = key: name: {
                __unkeyed = key;
                group = name;
                icon = "󰓩 ";
              };
            in [
              (map "<leader>a" "AI")
              (map "<leader>c" "Copilot")
              (map "<leader>d" "DAP")
              (map "<leader>e" "Edit")
              (map "<leader>f" "Find")
              (map "<leader>fs" "Search")
              (map "<leader>g" "Git")
              (map "<leader>gt" "Toggle")
              (map "<leader>h" "Arrow")
              (map "<leader>l" "LSP")
              (map "<leader>lt" "Telescope")
              (map "<leader>n" "Notes")
              (map "<leader>o" "Open")
              (map "<leader>t" "Toggle")
            ];
          };
        };

        extraPlugins = [
          pkgs.gp-nvim
        ];

        extraConfigLua = ''
          local home = vim.fn.expand("$HOME")
          local gp = require("gp")

          gp.setup({
              openai_api_key = { "cat", home .. "/.ssh/openai.key" },
              image = { secret = { "cat", home .. "/.ssh/openai.key" } },

              providers = {
                  openai = {
                      disable = false,
                      endpoint = "https://api.openai.com/v1/chat/completions",
                  },
              },

              agents = {
                  {
                      name = "ChatGPT4",
                      provider = "openai",
                      chat = true,
                      command = false,
                      model = { model = "gpt-4", temperature = 0.1, top_p = 1 },
                      system_prompt = require("gp.defaults").chat_system_prompt,
                  },
                  {
                      name = "CodeGPT4",
                      provider = "openai",
                      chat = false,
                      command = true,
                      model = { model = "gpt-4", temperature = 0.1, top_p = 1 },
                      system_prompt = require("gp.defaults").code_system_prompt,
                  },
              },

              chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-a><C-a>" },
              chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-a>d" },
              chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-a>s" },
              chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-a>c" },
          })

          local function map(l, r, desc)
            vim.keymap.set("n", l, r, { desc = desc })
          end

          map('<leader>aa', '<cmd>GpChatToggle vsplit<cr>', 'Toggle Chat')
          map('<leader>an', '<cmd>GpChatNew vsplit<cr>', 'New Chat')
          map('<leader>af', '<cmd>GpChatFinder<cr>', 'Find Chats')
          map('<leader>ap', '<cmd>GpChatPaste vsplit<cr>', 'Paste to Chat')
          map('<leader>ar', '<cmd>GpChatRespond<cr>', 'Request Response')
          map('<leader>ad', '<cmd>GpChatDelete<cr>', 'Delete Chat')
          map('<leader>as', '<cmd>GpStop<cr>', 'Stop Chat')
          map('<leader>ai', '<cmd>GpImplement<cr>', 'Implement Selected Comment')
          map('<leader>ac', '<cmd>GpContext vsplit<cr>', 'Custom Context')
        '';
      };
    };
  };
}
