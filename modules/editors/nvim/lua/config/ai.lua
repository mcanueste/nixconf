local whichkey = require("which-key")
local copilot = require("copilot")
local chatgpt = require("chatgpt")

local function init()
    local home = vim.fn.expand("$HOME")
    whichkey.register({ a = { name = "ai" } }, { prefix = "<leader>" })

    require("copilot").setup({
        panel = {
            enabled = true,
            auto_refresh = false,
            keymap = {
                jump_prev = "[[",
                jump_next = "]]",
                accept = "<CR>",
                refresh = "gr",
                open = "<M-CR>",
            },
            layout = {
                position = "bottom", -- | top | left | right
                ratio = 0.4,
            },
        },
        suggestion = {
            auto_trigger = true,
            keymap = {
                accept = "<M-l>",
                dismiss = "<M-h>",
                next = "<M-j>",
                prev = "<M-k>",
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

    chatgpt.setup({
        api_key_cmd = "cat " .. home .. "/.ssh/chatgpt.key",
        openai_params = {
            model = "gpt-3.5-turbo",
            max_tokens = 300,
        },
        openai_edit_params = {
            -- model = "gpt-3.5-turbo",
            model = "gpt-4", -- NOTE: don't have access now for some weird reason
        },
    })

    -- FIXME: buggy UI with this
    vim.keymap.set("n", "<leader>ac", function()
        chatgpt.complete_code()
    end, { noremap = true, desc = "ChatGPT Complete" })

    vim.keymap.set("n", "<leader>ae", function()
        chatgpt.edit_with_instructions()
    end, { noremap = true, desc = "ChatGPT Edit" })

    vim.keymap.set("n", "<leader>aa", function()
        chatgpt.selectAwesomePrompt()
    end, { noremap = true, desc = "ChatGPT Act as" })

    vim.keymap.set("n", "<leader>ap", function()
        chatgpt.openChat()
    end, { noremap = true, desc = "ChatGPT Prompt" })

    vim.keymap.set("n", "<leader>at", "<cmd>ChatGPTRun add_tests<cr>", { noremap = true, desc = "ChatGPT Add Test" })
    vim.keymap.set("n", "<leader>af", "<cmd>ChatGPTRun fix_bugs<cr>", { noremap = true, desc = "ChatGPT Fix Bugs" })
    -- FIXME: works a bit weird
    vim.keymap.set("n", "<leader>ad", "<cmd>ChatGPTRun docstring<cr>", { noremap = true, desc = "ChatGPT Docstring" })
    vim.keymap.set(
        "n",
        "<leader>ae",
        "<cmd>ChatGPTRun explain_code<cr>",
        { noremap = true, desc = "ChatGPT Explain Code" }
    )
    vim.keymap.set(
        "n",
        "<leader>ao",
        "<cmd>ChatGPTRun optimize_code<cr>",
        { noremap = true, desc = "ChatGPT Optimize Code" }
    )
    vim.keymap.set(
        "n",
        "<leader>ar",
        "<cmd>ChatGPTRun code_readability_analysis<cr>",
        { noremap = true, desc = "ChatGPT Code Readability Analysis" }
    )

    -- TODO: optimize these later when needed
    vim.keymap.set("n", "<leader>as", "<cmd>ChatGPTRun summarize<cr>", { noremap = true, desc = "ChatGPT Summarize" })
    vim.keymap.set("n", "<leader>an", "<cmd>ChatGPTRun translate<cr>", { noremap = true, desc = "ChatGPT Translate" })
    vim.keymap.set("n", "<leader>ak", "<cmd>ChatGPTRun keywords<cr>", { noremap = true, desc = "ChatGPT Keywords" })
    vim.keymap.set(
        "n",
        "<leader>ag",
        "<cmd>ChatGPTRun grammar_correction<cr>",
        { noremap = true, desc = "ChatGPT Grammar Correction" }
    )
end

return { init = init }
