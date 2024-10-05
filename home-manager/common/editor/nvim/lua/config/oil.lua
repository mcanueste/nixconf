local function init()
    -- oil file browser
    -- See: https://github.com/stevearc/oil.nvim
    require("oil").setup({
        -- Id is automatically added at the beginning, and name at the end
        -- See :help oil-columns
        columns = {
            "icon",
            "permissions",
            "size",
            "mtime",
        },
        -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = true,
        -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
        skip_confirm_for_simple_edits = false,
        view_options = {
            -- Show files and directories that start with "."
            show_hidden = true,
        },
        use_default_keymaps = false,
        keymaps = {
            ["<CR>"] = "actions.select",
            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["`"] = "actions.cd",
            ["~"] = "actions.tcd",

            ["<leader>b?"] = "actions.show_help",

            ["<leader>bv"] = "actions.select_vsplit",
            ["<leader>bs"] = "actions.select_split",

            ["<leader>bp"] = "actions.preview",
            ["<leader>bq"] = "actions.close",
            ["<leader>br"] = "actions.refresh",

            ["<leader>bS"] = "actions.change_sort",
            ["<leader>bo"] = "actions.open_external",
            ["<leader>bh"] = "actions.toggle_hidden",
            ["<leader>bt"] = "actions.toggle_trash",
        },
    })

    vim.api.nvim_set_keymap("n", "<leader>oe", "<CMD>Oil<CR>", { noremap = true, desc = "File Browser" })
end

return { init = init }
