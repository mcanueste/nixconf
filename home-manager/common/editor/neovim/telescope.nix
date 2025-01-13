{
  programs.nixvim.plugins = {
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

      luaConfig.post =
        #lua
        ''
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
        "<leader>fsM" = map "man_pages" "Man Pages";
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed = "<leader>f";
        group = "Find";
        icon = "";
      }
      {
        __unkeyed = "<leader>fs";
        group = "Search";
        icon = "";
      }
    ];
  };
}
