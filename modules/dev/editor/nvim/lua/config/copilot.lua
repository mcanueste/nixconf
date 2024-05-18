local function init()
    require("copilot").setup({
        panel = {
            enabled = true,
            auto_refresh = false,
            keymap = {
                jump_prev = "[[",
                jump_next = "]]",
                accept = "<CR>",
                refresh = "<C-r>",
                open = "<C-CR>",
            },
            layout = {
                position = "bottom", -- | top | left | right
                ratio = 0.4,
            },
        },

        suggestion = {
            auto_trigger = true,
            keymap = {
                accept = "<C-l>",
                dismiss = "<C-h>",
                next = "<C-j>",
                prev = "<C-k>",
                accept_word = false,
                accept_line = false,
            },
        },

        filetypes = {
            yaml = true,
            markdown = true,
            help = false,
            gitcommit = true,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
        },
    })

    vim.keymap.set("n", "<leader>cT", function()
        require("copilot.suggestion").toggle_auto_trigger()
    end, { noremap = true, desc = "Toggle Copilot Auto Trigger" })

    require("CopilotChat").setup({
        model = "gpt-4", -- GPT model to use, 'gpt-3.5-turbo' or 'gpt-4'
        temperature = 0.1, -- GPT temperature

        context = nil, -- Default context to use, 'buffers', 'buffer' or none (can be specified manually in prompt via @).
        history_path = vim.fn.stdpath("data") .. "/copilotchat_history", -- Default path to stored history
        callback = nil, -- Callback to use when ask response is received
    })

    vim.keymap.set("n", "<leader>cc", ":CopilotChatToggle<cr>", { noremap = true, desc = "Toggle Copilot Chat" })
    vim.keymap.set("n", "<leader>ce", ":CopilotChatExplain<cr>", { noremap = true, desc = "Explain" })
    vim.keymap.set("n", "<leader>cf", ":CopilotChatFix<cr>", { noremap = true, desc = "Fix" })
    vim.keymap.set("n", "<leader>co", ":CopilotChatOptimize<cr>", { noremap = true, desc = "Optimize" })
    vim.keymap.set("n", "<leader>cd", ":CopilotChatDocs<cr>", { noremap = true, desc = "Docs" })
    vim.keymap.set("n", "<leader>ct", ":CopilotChatTests<cr>", { noremap = true, desc = "Tests" })
    vim.keymap.set("n", "<leader>ci", ":CopilotChatFixDiagnostic<cr>", { noremap = true, desc = "Fix Diagnostic" })
    vim.keymap.set("n", "<leader>cm", ":CopilotChatCommit<cr>", { noremap = true, desc = "Commit Message" })
    vim.keymap.set(
        "n",
        "<leader>cs",
        ":CopilotChatCommitStaged<cr>",
        { noremap = true, desc = "Commit Message (Staged)" }
    )
end

return { init = init }
