local function init()
    -- TODO remove?
    require("cloak").setup({
        enabled = false,
        patterns = {
            {
                file_pattern = { ".env", ".env.local", "*.nix", "*.py" },
                cloak_pattern = { "=.+" },
            },
        },
    })

    vim.keymap.set("n", "<leader>bc", "<cmd>CloakToggle<cr>", { noremap = true, desc = "Toggle Cloak" })
end

return { init = init }
