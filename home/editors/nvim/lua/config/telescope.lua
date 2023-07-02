local telescope = require("telescope")
local utils = require("config.utils")

local function init()
    telescope.setup({
        defaults = {
            file_ignore_patterns = {
                "node_modules/.*",
            },
            prompt_prefix = " ",
            selection_caret = " ",
            mappings = {
                i = {
                    ["<M-g>"] = function()
                        utils.telescope("find_files", { no_ignore = true })()
                    end,
                    ["<M-.>"] = function()
                        utils.telescope("find_files", { hidden = true })()
                    end,
                    -- ["<C-M-k>"] = function(...)
                    --   return require("telescope.actions").cycle_history_next(...)
                    -- end,
                    -- ["<C-M-j>"] = function(...)
                    --   return require("telescope.actions").cycle_history_prev(...)
                    -- end,
                    -- ["<C-f>"] = function(...)
                    --   return require("telescope.actions").preview_scrolling_down(...)
                    -- end,
                    -- ["<C-b>"] = function(...)
                    --   return require("telescope.actions").preview_scrolling_up(...)
                    -- end,
                    -- ["<M-t>"] = function(...)
                    --   return require("trouble.providers.telescope").open_with_trouble(...)
                    -- end,
                    -- ["<C-M-t>"] = function(...)
                    --   return require("trouble.providers.telescope").open_selected_with_trouble(...)
                    -- end,
                },
                n = {
                    ["q"] = function(...)
                        return require("telescope.actions").close(...)
                    end,
                },
            },
        },
    })
    vim.keymap.set("n", "<leader><space>", "<cmd>Telescope resume<cr>", { noremap = true, desc = "Resume" })
    vim.keymap.set(
        "n",
        "<leader>/",
        "<cmd>Telescope current_buffer_fuzzy_find<cr>",
        { noremap = true, desc = "Find in Buffer" }
    )
    -- find
    vim.keymap.set("n", "<leader>ff", utils.telescope("files"), { noremap = true, desc = "Find Files (root dir)" })
    vim.keymap.set(
        "n",
        "<leader>fF",
        utils.telescope("files", { cwd = false }),
        { noremap = true, desc = "Find Files (cwd)" }
    )
    vim.keymap.set("n", "<leader>fp", "<cmd>Telescope git_files<cr>", { noremap = true, desc = "Git Files" })
    vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { noremap = true, desc = "Recent" })
    vim.keymap.set("n", "<leader>fR", "<cmd>Telescope registers<cr>", { noremap = true, desc = "Registers" })
    vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, desc = "Buffers" })
    vim.keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>", { noremap = true, desc = "Marks" })
    vim.keymap.set("n", "<leader>fg", utils.telescope("live_grep"), { noremap = true, desc = "Grep (root dir)" })
    vim.keymap.set(
        "n",
        "<leader>fG",
        utils.telescope("live_grep", { cwd = false }),
        { noremap = true, desc = "Grep (cwd)" }
    )
    vim.keymap.set("n", "<leader>fw", utils.telescope("grep_string"), { noremap = true, desc = "Word (root dir)" })
    vim.keymap.set(
        "n",
        "<leader>fW",
        utils.telescope("grep_string", { cwd = false }),
        { noremap = true, desc = "Word (cwd)" }
    )
    vim.keymap.set(
        "n",
        "<leader>fc",
        "<cmd>Telescope command_history<cr>",
        { noremap = true, desc = "Command History" }
    )
    -- search
    vim.keymap.set("n", "<leader>sa", "<cmd>Telescope autocommands<cr>", { noremap = true, desc = "Auto Commands" })
    vim.keymap.set("n", "<leader>sc", "<cmd>Telescope commands<cr>", { noremap = true, desc = "Commands" })
    vim.keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { noremap = true, desc = "Key Maps" })
    vim.keymap.set("n", "<leader>sm", "<cmd>Telescope man_pages<cr>", { noremap = true, desc = "Man Pages" })
    vim.keymap.set("n", "<leader>so", "<cmd>Telescope vim_options<cr>", { noremap = true, desc = "Options" })
    vim.keymap.set("n", "<leader>sf", "<cmd>Telescope filetypes<cr>", { noremap = true, desc = "Filetypes" })
    vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { noremap = true, desc = "Help Pages" })
    vim.keymap.set(
        "n",
        "<leader>sH",
        "<cmd>Telescope highlights<cr>",
        { noremap = true, desc = "Search Highlight Groups" }
    )
    -- git
    vim.keymap.set("n", "<leader>vc", "<cmd>Telescope git_commits<CR>", { noremap = true, desc = "Commits" })
    vim.keymap.set("n", "<leader>vC", "<cmd>Telescope git_bcommits<CR>", { noremap = true, desc = "Buffer Commits" })
    vim.keymap.set("n", "<leader>vt", "<cmd>Telescope git_stash<CR>", { noremap = true, desc = "Stash" })
    vim.keymap.set("n", "<leader>vr", "<cmd>Telescope git_branches<CR>", { noremap = true, desc = "Branches" })
    -- lsp
    -- vim.keymap.set("n", "<leader>lfl", "<cmd>Telescope diagnostics<cr>", { noremap = true, desc = "Diagnostics" })
    -- vim.keymap.set("n", "<leader>lfd", "<cmd>Telescope lsp_definitions<cr>", { noremap = true, desc = "Definitions" })
    -- vim.keymap.set("n", "<leader>lfr", "<cmd>Telescope lsp_references<cr>", { noremap = true, desc = "References" })
    -- vim.keymap.set(
    --     "n",
    --     "<leader>lfi",
    --     "<cmd>Telescope lsp_implementations<cr>",
    --     { noremap = true, desc = "Implementations" }
    -- )
    -- vim.keymap.set(
    --     "n",
    --     "<leader>lft",
    --     "<cmd>Telescope lsp_type_definitions<cr>",
    --     { noremap = true, desc = "Definition" }
    -- )
    -- vim.keymap.set(
    --     "n",
    --     "<leader>lfw",
    --     "<cmd>Telescope lsp_workspace_symbols<CR>",
    --     { noremap = true, desc = "Workspace Symbols" }
    -- )
    -- vim.keymap.set(
    --     "n",
    --     "<leader>lfW",
    --     "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
    --     { noremap = true, desc = "Dynamic Workspace Symbols" }
    -- )
    -- vim.keymap.set(
    --     "n",
    --     "<leader>lfc",
    --     "<cmd>Telescope lsp_incoming_calls<CR>",
    --     { noremap = true, desc = "Incoming Calls" }
    -- )
    -- vim.keymap.set(
    --     "n",
    --     "<leader>lfC",
    --     "<cmd>Telescope lsp_outgoing_calls<CR>",
    --     { noremap = true, desc = "Outgoing Calls" }
    -- )
    -- vim.keymap.set(
    --     "n",
    --     "<leader>lfs",
    --     utils.telescope("lsp_document_symbols", {
    --         symbols = {
    --             "Class",
    --             "Function",
    --             "Method",
    --             "Constructor",
    --             "Interface",
    --             "Module",
    --             "Struct",
    --             "Trait",
    --             "Field",
    --             "Property",
    --         },
    --     }),
    --     { noremap = true, desc = "Symbols" }
    -- )
end

return { init = init }
