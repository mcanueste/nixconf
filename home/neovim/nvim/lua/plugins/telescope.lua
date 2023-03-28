local utils = require("config.utils")

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  -- event = "VeryLazy",
  version = false, -- telescope did only one release, so use HEAD for now
  keys = {
    { "<leader><space>", "<cmd>Telescope resume<cr>",                               desc = "Resume" },
    { "<leader>/",       "<cmd>Telescope current_buffer_fuzzy_find<cr>",            desc = "Find in Buffer" },
    -- find
    { "<leader>ff",      utils.telescope("files"),                                  desc = "Find Files (root dir)" },
    { "<leader>fF",      utils.telescope("files", { cwd = false }),                 desc = "Find Files (cwd)" },
    { "<leader>fp",      "<cmd>Telescope git_files<cr>",                            desc = "Git Files" },
    { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",                             desc = "Recent" },
    { "<leader>fR",      "<cmd>Telescope registers<cr>",                            desc = "Registers" },
    { "<leader>fb",      "<cmd>Telescope buffers<cr>",                              desc = "Buffers" },
    { "<leader>fc",      "<cmd>Telescope command_history<cr>",                      desc = "Command History" },
    { "<leader>fg",      utils.telescope("live_grep"),                              desc = "Grep (root dir)" },
    { "<leader>fG",      utils.telescope("live_grep", { cwd = false }),             desc = "Grep (cwd)" },
    { "<leader>fw",      utils.telescope("grep_string"),                            desc = "Word (root dir)" },
    { "<leader>fW",      utils.telescope("grep_string", { cwd = false }),           desc = "Word (cwd)" },
    { "<leader>fm",      "<cmd>Telescope marks<cr>",                                desc = "Marks" },
    { "<leader>fq",      "<cmd>Telescope quickfix<cr>",                             desc = "Quickfix" },
    { "<leader>fQ",      "<cmd>Telescope quickfixhistory<cr>",                      desc = "Quickfix History" },
    { "<leader>fS",      "<cmd>Telescope spell_suggests<cr>",                       desc = "Spell Suggestions" },
    -- git
    { "<leader>gfc",     "<cmd>Telescope git_commits<CR>",                          desc = "Commits" },
    { "<leader>gfC",     "<cmd>Telescope git_bcommits<CR>",                         desc = "Buffer Commits" },
    { "<leader>gfs",     "<cmd>Telescope git_status<CR>",                           desc = "Status" },
    { "<leader>gfS",     "<cmd>Telescope git_stash<CR>",                            desc = "Stash" },
    { "<leader>gfb",     "<cmd>Telescope git_branches<CR>",                         desc = "Branches" },
    -- search
    { "<leader>sa",      "<cmd>Telescope autocommands<cr>",                         desc = "Auto Commands" },
    { "<leader>sc",      "<cmd>Telescope commands<cr>",                             desc = "Commands" },
    { "<leader>sh",      "<cmd>Telescope help_tags<cr>",                            desc = "Help Pages" },
    { "<leader>sH",      "<cmd>Telescope highlights<cr>",                           desc = "Search Highlight Groups" },
    { "<leader>sk",      "<cmd>Telescope keymaps<cr>",                              desc = "Key Maps" },
    { "<leader>sM",      "<cmd>Telescope man_pages<cr>",                            desc = "Man Pages" },
    { "<leader>so",      "<cmd>Telescope vim_options<cr>",                          desc = "Options" },
    { "<leader>sC",      utils.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
    { "<leader>sf",      "<cmd>Telescope filetypes<cr>",                            desc = "Filetypes" },
    -- lsp
    { "<leader>fll",     "<cmd>Telescope diagnostics<cr>",                          desc = "Diagnostics" },
    { "<leader>fld",     "<cmd>Telescope lsp_definitions<cr>",                      desc = "Definitions" },
    { "<leader>flr",     "<cmd>Telescope lsp_references<cr>",                       desc = "References" },
    { "<leader>fli",     "<cmd>Telescope lsp_implementations<cr>",                  desc = "Implementations" },
    { "<leader>flt",     "<cmd>Telescope lsp_type_definitions<cr>",                 desc = "Definition" },
    { "<leader>flw",     "<cmd>Telescope lsp_workspace_symbols<CR>",                desc = "Workspace Symbols" },
    { "<leader>flW",     "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",        desc = "Dynamic Workspace Symbols" },
    { "<leader>flc",     "<cmd>Telescope lsp_incoming_calls<CR>",                   desc = "Incoming Calls" },
    { "<leader>flC",     "<cmd>Telescope lsp_outgoing_calls<CR>",                   desc = "Outgoing Calls" },
    {
      "<leader>fls",
      utils.telescope("lsp_document_symbols", {
        symbols = {
          "Class",
          "Function",
          "Method",
          "Constructor",
          "Interface",
          "Module",
          "Struct",
          "Trait",
          "Field",
          "Property",
        },
      }),
      desc = "Symbols",
    },
  },
  opts = {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      mappings = {
        i = {
          ["<M-t>"] = function(...)
            return require("trouble.providers.telescope").open_with_trouble(...)
          end,
          ["<C-M-t>"] = function(...)
            return require("trouble.providers.telescope").open_selected_with_trouble(...)
          end,
          ["<M-g>"] = function()
            Util.telescope("find_files", { no_ignore = true })()
          end,
          ["<M-.>"] = function()
            Util.telescope("find_files", { hidden = true })()
          end,
          ["<C-M-k>"] = function(...)
            return require("telescope.actions").cycle_history_next(...)
          end,
          ["<C-M-j>"] = function(...)
            return require("telescope.actions").cycle_history_prev(...)
          end,
          ["<C-f>"] = function(...)
            return require("telescope.actions").preview_scrolling_down(...)
          end,
          ["<C-b>"] = function(...)
            return require("telescope.actions").preview_scrolling_up(...)
          end,
        },
        n = {
          ["q"] = function(...)
            return require("telescope.actions").close(...)
          end,
        },
      },
    },
  },
}
