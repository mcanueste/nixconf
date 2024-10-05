local function init()
    -- trouble.nvim for better lists
    -- See: https://github.com/folke/trouble.nvim
    local trouble = require("trouble")
    trouble.setup()

    vim.keymap.set("n", "[q", function()
        if trouble.is_open() then
            trouble.prev({ skip_groups = true, jump = true })
        else
            vim.cmd.cprev()
        end
    end, { noremap = true, desc = "Previous trouble item" })
    vim.keymap.set("n", "]q", function()
        if trouble.is_open() then
            trouble.next({ skip_groups = true, jump = true })
        else
            vim.cmd.cnext()
        end
    end, { noremap = true, desc = "Next trouble item" })

    vim.keymap.set(
        "n",
        "<leader>ld",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        { noremap = true, desc = "Diagnostics" }
    )
    vim.keymap.set(
        "n",
        "<leader>lwd",
        "<cmd>Trouble diagnostics toggle<cr>",
        { noremap = true, desc = "Workspace Diagnostics" }
    )

    vim.keymap.set("n", "<leader>lq", "<cmd>Trouble quickfix toggle<cr>", { noremap = true, desc = "Quickfix List" })
    vim.keymap.set("n", "<leader>ll", "<cmd>Trouble loclist toggle<cr>", { noremap = true, desc = "Location List" })

    -- overridden in LspAttach
    vim.keymap.set("n", "<leader>ls", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols" })

    -- LspAttach mappings
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("TroubleLspConfig", {}),
        callback = function(ev)
            local function opts(desc)
                return { buffer = ev.buf, desc = desc }
            end

            vim.keymap.set("n", "gd", "<cmd>Trouble lsp_definitions toggle<cr>", opts("Definitions [LSP]"))
            vim.keymap.set("n", "gD", "<cmd>Trouble lsp_declarations toggle<cr>", opts("Declarations [LSP]"))
            vim.keymap.set("n", "gi", "<cmd>Trouble lsp_implementations toggle<cr>", opts("Implementations [LSP]"))
            vim.keymap.set("n", "gr", "<cmd>Trouble lsp_references toggle<cr>", opts("References [LSP]"))

            -- I don't use tabs so overriding gt (go to next tab)
            vim.keymap.set("n", "gt", "<cmd>Trouble lsp_type_definitions toggle<cr>", opts("Type Definitions [LSP]"))

            vim.keymap.set(
                "n",
                "<leader>ls",
                "<cmd>Trouble lsp_document_symbols toggle<cr>",
                opts("Document Symbols [LSP]")
            )
        end,
    })
end

return { init = init }
