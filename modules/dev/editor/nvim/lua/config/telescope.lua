local function init()
    -- telescope for fuzzy find
    -- See: https://github.com/nvim-telescope/telescope.nvim
    local telescope = require("telescope")
    local utils = require("config.utils")

    local telescopeConfig = require("telescope.config")
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
    table.insert(vimgrep_arguments, "--hidden")

    telescope.setup({
        defaults = {
            file_ignore_patterns = {
                ".git/.*",
                "node_modules/.*",
                "env/.*",
                ".venv/.*",
            },
            vimgrep_arguments = vimgrep_arguments,
            prompt_prefix = " ",
            selection_caret = " ",
            mappings = {
                i = {
                    ["<C-t>"] = function(...)
                        return require("trouble.sources.telescope").open(...)
                    end,
                },
                n = {
                    ["<C-t>"] = function(...)
                        return require("trouble.sources.telescope").open(...)
                    end,
                    ["q"] = function(...)
                        return require("telescope.actions").close(...)
                    end,
                },
            },
        },
        pickers = {
            find_files = {
                find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
            },
        },
        extensions = {},
    })
    telescope.load_extension("fzf") -- faster searches with fzf native

    vim.keymap.set("n", "<leader><space>", "<cmd>Telescope resume<cr>", { noremap = true, desc = "Resume Telescope" })

    -------------------------------------------- Find
    vim.keymap.set("n", "<leader>ff", utils.telescope_find_files, { noremap = true, desc = "Find Files" })
    vim.keymap.set("n", "<leader>fF", "<cmd>Telescope find_files<cr>", { noremap = true, desc = "Find Files (cwd)" })
    vim.keymap.set("n", "<leader>fg", utils.telescope_live_grep, { noremap = true, desc = "Grep Files" })
    vim.keymap.set("n", "<leader>fG", "<cmd>Telescope live_grep<cr>", { noremap = true, desc = "Grep Files (cwd)" })
    vim.keymap.set("n", "<leader>fw", utils.telescope_grep_string, { noremap = true, desc = "Grep String" })
    vim.keymap.set("n", "<leader>fW", "<cmd>Telescope grep_string<cr>", { noremap = true, desc = "Grep String (cwd)" })
    vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { noremap = true, desc = "Recent" })
    vim.keymap.set("n", "<leader>fR", "<cmd>Telescope registers<cr>", { noremap = true, desc = "Registers" })
    vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, desc = "Buffers" })
    vim.keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>", { noremap = true, desc = "Marks" })
    vim.keymap.set(
        "n",
        "<leader>f/",
        "<cmd>Telescope current_buffer_fuzzy_find<cr>",
        { noremap = true, desc = "Find in Buffer" }
    )
    vim.keymap.set(
        "n",
        "<leader>fc",
        "<cmd>Telescope command_history<cr>",
        { noremap = true, desc = "Command History" }
    )

    -------------------------------------------- Search
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

    -------------------------------------------- Git
    vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { noremap = true, desc = "Commits" })
    vim.keymap.set("n", "<leader>gC", "<cmd>Telescope git_bcommits<cr>", { noremap = true, desc = "Buffer Commits" })
    vim.keymap.set("n", "<leader>gB", "<cmd>Telescope git_branches<cr>", { noremap = true, desc = "Branches" })
    vim.keymap.set("n", "<leader>gh", "<cmd>Telescope git_stash<cr>", { noremap = true, desc = "Stash" })

    -------------------------------------------- Worktree
    -- TODO fix
    telescope.load_extension("git_worktree")
    -- <Enter> - switches to that worktree
    -- <c-d> - deletes that worktree
    -- <c-f> - toggles forcing of the next deletion
    vim.keymap.set("n", "<leader>gw", function()
        telescope.extensions.git_worktree.git_worktrees()
    end, { noremap = true, desc = "Worktree" })

    vim.keymap.set("n", "<leader>gW", function()
        telescope.extensions.git_worktree.create_git_worktree()
    end, { noremap = true, desc = "Create Worktree" })
end

return { init = init }
