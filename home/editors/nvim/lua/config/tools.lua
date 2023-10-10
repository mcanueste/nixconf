local splitjoin = require("mini.splitjoin")
local surround = require("mini.surround")
local comment = require("mini.comment")
local telescope = require("telescope")
local whichkey = require("which-key")
local utils = require("config.utils")
local pairs = require("mini.pairs")
-- local files = require("mini.files")
local trouble = require("trouble")
local harpoon = require("harpoon")

local function init()
    -------------------------------------------- Basics

    -- mini.pairs for auto pairing brackets etc.
    -- See: https://github.com/echasnovski/mini.pairs
    pairs.setup()

    -- mini.split for splitting and joininig lists/parameters/structs
    -- See: https://github.com/echasnovski/mini.splitjoin
    splitjoin.setup()

    -- mini.surround for adding/deleting surrounding objects
    -- See: https://github.com/echasnovski/mini.surround
    surround.setup()

    -- mini.comment for commenting strings
    -- See: https://github.com/echasnovski/mini.comment
    comment.setup({
        options = {
            custom_commentstring = function()
                return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
            end,
        },
    })

    -------------------------------------------- File explorer
    whichkey.register({ o = { name = "open" } }, { prefix = "<leader>" })

    -- mini.files for small file explorer
    -- See: https://github.com/echasnovski/mini.files
    -- files.setup()
    -- vim.keymap.set("n", "<leader>oe", function()
    --     files.open()
    -- end, { noremap = true, desc = "Files" })

    -------------------------------------------- Harpoon
    whichkey.register({ h = { name = "harpoon" } }, { prefix = "<leader>" })

    -- harpoon for file navigation
    -- See: https://github.com/ThePrimeagen/harpoon
    harpoon.setup({
        global_settings = {
            -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
            save_on_toggle = true,
            -- closes any tmux windows that harpoon creates when you close Neovim.
            tmux_autoclose_windows = false,
            -- filetypes that you want to prevent from adding to the harpoon list menu.
            excluded_filetypes = { "harpoon" },
        },
    })

    vim.keymap.set("n", "<leader>hh", function()
        require("harpoon.mark").add_file()
    end, { noremap = true, desc = "Mark file" })
    vim.keymap.set("n", "<leader>hm", function()
        require("harpoon.ui").toggle_quick_menu()
    end, { noremap = true, desc = "Menu" })
    vim.keymap.set("n", "<leader>hn", function()
        require("harpoon.ui").nav_next()
    end, { noremap = true, desc = "Open next" })
    vim.keymap.set("n", "<leader>hp", function()
        require("harpoon.ui").nav_prev()
    end, { noremap = true, desc = "Open prev" })
    vim.keymap.set("n", "<leader>hf", function()
        require("harpoon.ui").nav_file(1)
    end, { noremap = true, desc = "Open f" })
    vim.keymap.set("n", "<leader>hd", function()
        require("harpoon.ui").nav_file(2)
    end, { noremap = true, desc = "Open d" })
    vim.keymap.set("n", "<leader>hs", function()
        require("harpoon.ui").nav_file(3)
    end, { noremap = true, desc = "Open s" })
    vim.keymap.set("n", "<leader>ha", function()
        require("harpoon.ui").nav_file(4)
    end, { noremap = true, desc = "Open a" })

    -------------------------------------------- Trouble

    -- trouble.nvim for pretty lists
    -- See: https://github.com/folke/trouble.nvim
    -- NOTE: some lsp related keymaps are under `lsp.lua`
    trouble.setup()

    vim.keymap.set("n", "<leader>ol", "<cmd>TroubleToggle loclist<cr>", { noremap = true, desc = "Location List" })
    vim.keymap.set("n", "<leader>oq", "<cmd>TroubleToggle quickfix<cr>", { noremap = true, desc = "Quickfix List" })
    vim.keymap.set("n", "[q", function()
        if trouble.is_open() then
            trouble.previous({ skip_groups = true, jump = true })
        else
            vim.cmd.cprev()
        end
    end, { noremap = true, desc = "Previous trouble/quickfix item" })
    vim.keymap.set("n", "]q", function()
        if trouble.is_open() then
            trouble.next({ skip_groups = true, jump = true })
        else
            vim.cmd.cnext()
        end
    end, { noremap = true, desc = "Next trouble/quickfix item" })

    -------------------------------------------- Telescope

    -- telescope for fuzzy find
    -- See: https://github.com/nvim-telescope/telescope.nvim
    --
    -- NOTE: Some VCS related keymaps have been moved to `vcs.lua`
    -- NOTE: Some LSP related keymaps have been moved to `lsp.lua`
    telescope.setup({
        defaults = {
            file_ignore_patterns = {
                "node_modules/.*",
            },
            prompt_prefix = " ",
            selection_caret = " ",
            mappings = {
                i = {
                    ["<C-t>"] = function(...)
                        return require("trouble.providers.telescope").smart_open_with_trouble(...)
                    end,
                    -- ["<M-g>"] = function() -- FIXME: toggles for ignored files and hidden files
                    --     utils.telescope("find_files", { no_ignore = true })()
                    -- end,
                    -- ["<M-.>"] = function()
                    --     utils.telescope("find_files", { hidden = true })()
                    -- end,
                },
                n = {
                    ["q"] = function(...)
                        return require("telescope.actions").close(...)
                    end,
                    ["<C-t>"] = function(...)
                        return require("trouble.providers.telescope").smart_open_with_trouble(...)
                    end,
                },
            },
        },
    })
    telescope.load_extension("file_browser") -- add file browser extension

    vim.api.nvim_set_keymap(
        "n",
        "<space>oe",
        ":Telescope file_browser<CR>",
        { noremap = true, desc = "File Browser" }
    )
    vim.api.nvim_set_keymap(
        "n",
        "<space>oE",
        ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
        { noremap = true, desc = "File Browser (cwd)" }
    )

    vim.keymap.set("n", "<leader><space>", "<cmd>Telescope resume<cr>", { noremap = true, desc = "Resume Telescope" })

    -------------------------------------------- Find
    whichkey.register({ f = { name = "find" } }, { prefix = "<leader>" })

    vim.keymap.set("n", "<leader>ff", utils.telescope("files"), { noremap = true, desc = "Find Files (root dir)" })
    vim.keymap.set(
        "n",
        "<leader>fF",
        utils.telescope("files", { cwd = false }),
        { noremap = true, desc = "Find Files (cwd)" }
    )
    vim.keymap.set(
        "n",
        "<leader>f/",
        "<cmd>Telescope current_buffer_fuzzy_find<cr>",
        { noremap = true, desc = "Find in Buffer" }
    )
    vim.keymap.set("n", "<leader>fp", "<cmd>Telescope git_files<cr>", { noremap = true, desc = "Git Files" })
    vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { noremap = true, desc = "Recent" })
    vim.keymap.set("n", "<leader>fR", "<cmd>Telescope registers<cr>", { noremap = true, desc = "Registers" })
    vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, desc = "Buffers" })
    vim.keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>", { noremap = true, desc = "Marks" })
    vim.keymap.set(
        "n",
        "<leader>fc",
        "<cmd>Telescope command_history<cr>",
        { noremap = true, desc = "Command History" }
    )

    -------------------------------------------- Grep
    whichkey.register({ g = { name = "grep" } }, { prefix = "<leader>" })

    vim.keymap.set("n", "<leader>fg", utils.telescope("live_grep"), { noremap = true, desc = "Grep (root dir)" })
    vim.keymap.set(
        "n",
        "<leader>fG",
        utils.telescope("live_grep", { cwd = false }),
        { noremap = true, desc = "Grep (cwd)" }
    )
    vim.keymap.set("n", "<leader>gw", utils.telescope("grep_string"), { noremap = true, desc = "Word (root dir)" })
    vim.keymap.set(
        "n",
        "<leader>gW",
        utils.telescope("grep_string", { cwd = false }),
        { noremap = true, desc = "Word (cwd)" }
    )

    -------------------------------------------- Search
    whichkey.register({ s = { name = "search" } }, { prefix = "<leader>" })

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
end

return { init = init }
