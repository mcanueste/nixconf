local function init()
    local home = vim.fn.expand("$HOME")
    local chatgpt = require("chatgpt")

    chatgpt.setup({
        api_key_cmd = "cat " .. home .. "/.ssh/openai.key",
        predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
        openai_params = {
            model = "gpt-4o",
            frequency_penalty = 0,
            presence_penalty = 0,
            max_tokens = 300,
            temperature = 0,
            top_p = 1,
            n = 1,
        },
        openai_edit_params = {
            -- model = "gpt-3.5-turbo",
            model = "gpt-4o",
            frequency_penalty = 0,
            presence_penalty = 0,
            temperature = 0,
            top_p = 1,
            n = 1,
        },
        edit_with_instructions = {
            diff = false,
            keymaps = {
                close = "<C-c>",
                accept = "<C-y>",
                toggle_diff = "<C-d>",
                toggle_settings = "<C-o>",
                toggle_help = "<C-h>",
                cycle_windows = "<Tab>",
                use_output_as_input = "<C-i>",
            },
        },
        chat = {
            sessions_window = {
                active_sign = " 󰄵 ",
                inactive_sign = " 󰄱 ",
            },
            keymaps = {
                close = "<C-c>",
                yank_last = "<C-y>",
                yank_last_code = "<C-k>",
                scroll_up = "<C-u>",
                scroll_down = "<C-d>",
                new_session = "<C-n>",
                cycle_windows = "<Tab>",
                cycle_modes = "<C-f>",
                next_message = "<C-j>",
                prev_message = "<C-k>",
                select_session = "<Space>",
                rename_session = "r",
                delete_session = "d",
                draft_message = "<C-r>",
                edit_message = "e",
                delete_message = "d",
                toggle_settings = "<C-o>",
                toggle_sessions = "<C-p>",
                toggle_help = "<C-h>",
                toggle_message_role = "<C-r>",
                toggle_system_role_open = "<C-s>",
                stop_generating = "<C-x>",
            },
        },
    })

    -- GPT Prompts
    vim.keymap.set("n", "<leader>ap", function()
        chatgpt.openChat()
    end, { noremap = true, desc = "ChatGPT Prompt" })

    vim.keymap.set("n", "<leader>aa", function()
        chatgpt.selectAwesomePrompt()
    end, { noremap = true, desc = "ChatGPT Act as" })

    -- Code related commands
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
    vim.keymap.set("n", "<leader>ae", function()
        chatgpt.edit_with_instructions()
    end, { noremap = true, desc = "ChatGPT Edit" })
    vim.keymap.set("n", "<leader>ad", "<cmd>ChatGPTRun docstring<cr>", { noremap = true, desc = "ChatGPT Docstring" })
    vim.keymap.set("n", "<leader>at", "<cmd>ChatGPTRun add_tests<cr>", { noremap = true, desc = "ChatGPT Add Test" })
    vim.keymap.set("n", "<leader>af", "<cmd>ChatGPTRun fix_bugs<cr>", { noremap = true, desc = "ChatGPT Fix Bugs" })
    vim.keymap.set(
        "n",
        "<leader>aE",
        "<cmd>ChatGPTRun explain_code<cr>",
        { noremap = true, desc = "ChatGPT Explain Code" }
    )

    -- Text editing related commands
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
