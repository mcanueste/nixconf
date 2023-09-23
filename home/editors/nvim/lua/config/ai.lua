local chatgpt = require("chatgpt")

local function init()
    vim.cmd([[ hi ChatGPTWindow guibg=#181825 guifg=#CDD6F4 ]])
    vim.cmd([[ hi ChatGPTBorder guibg=#181825 guifg=#89B4FA ]])

    local home = vim.fn.expand("$HOME")
    chatgpt.setup({
        api_key_cmd = "cat " .. home .. "/.ssh/chatgpt.key",
        yank_register = "+",
        edit_with_instructions = {
            diff = false,
            keymaps = {
                close = "<C-c>",
                accept = "<C-y>",
                toggle_diff = "<C-d>",
                toggle_settings = "<C-o>",
                cycle_windows = "<Tab>",
                use_output_as_input = "<C-i>",
            },
        },
        chat = {
            -- welcome_message = WELCOME_MESSAGE,
            loading_text = "Loading, please wait ...",
            question_sign = "",
            answer_sign = "ﮧ",
            max_line_length = 120,
            sessions_window = {
                border = {
                    style = "rounded",
                    text = {
                        top = " Sessions ",
                    },
                },
                win_options = {
                    winhighlight = "Normal:ChatGPTWindow,FloatBorder:ChatGPTBorder",
                },
            },
            keymaps = {
                close = { "<C-c>" },
                yank_last = "<C-y>",
                yank_last_code = "<C-k>",
                scroll_up = "<C-u>",
                scroll_down = "<C-d>",
                new_session = "<C-n>",
                cycle_windows = "<Tab>",
                cycle_modes = "<C-f>",
                select_session = "<Space>",
                rename_session = "r",
                delete_session = "d",
                draft_message = "<C-d>",
                toggle_settings = "<C-o>",
                toggle_message_role = "<C-r>",
                toggle_system_role_open = "<C-s>",
                stop_generating = "<C-x>",
            },
        },
        popup_layout = {
            default = "center",
            center = {
                width = "80%",
                height = "80%",
            },
            right = {
                width = "30%",
                width_settings_open = "50%",
            },
        },
        popup_window = {
            border = {
                highlight = "FloatBorder",
                style = "rounded",
                text = {
                    top = " ChatGPT ",
                },
            },
            win_options = {
                wrap = true,
                linebreak = true,
                foldcolumn = "1",
                winhighlight = "Normal:ChatGPTWindow,FloatBorder:ChatGPTBorder",
            },
            buf_options = {
                filetype = "markdown",
            },
        },
        system_window = {
            border = {
                highlight = "FloatBorder",
                style = "rounded",
                text = {
                    top = " SYSTEM ",
                },
            },
            win_options = {
                wrap = true,
                linebreak = true,
                foldcolumn = "2",
                winhighlight = "Normal:ChatGPTWindow,FloatBorder:ChatGPTBorder",
            },
        },
        popup_input = {
            prompt = "  ",
            border = {
                highlight = "FloatBorder",
                style = "rounded",
                text = {
                    top_align = "center",
                    top = " Prompt ",
                },
            },
            win_options = {
                winhighlight = "Normal:ChatGPTWindow,FloatBorder:ChatGPTBorder",
            },
            submit = "<C-Enter>",
            submit_n = "<Enter>",
            max_visible_lines = 20,
        },
        settings_window = {
            border = {
                style = "rounded",
                text = {
                    top = " Settings ",
                },
            },
            win_options = {
                winhighlight = "Normal:ChatGPTWindow,FloatBorder:ChatGPTBorder",
            },
        },
        openai_params = {
            model = "gpt-3.5-turbo",
            frequency_penalty = 0,
            presence_penalty = 0,
            max_tokens = 300,
            temperature = 0,
            top_p = 1,
            n = 1,
        },
        openai_edit_params = {
            model = "code-davinci-edit-001",
            temperature = 0,
            top_p = 1,
            n = 1,
        },
        actions_paths = {},
        show_quickfixes_cmd = "Trouble quickfix",
        predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
    })

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
    vim.keymap.set("n", "<leader>ae", "<cmd>ChatGPTRun explain_code<cr>", { noremap = true, desc = "ChatGPT Explain Code" })
    vim.keymap.set("n", "<leader>ao", "<cmd>ChatGPTRun optimize_code<cr>", { noremap = true, desc = "ChatGPT Optimize Code" })
    vim.keymap.set("n", "<leader>af", "<cmd>ChatGPTRun fix_bugs<cr>", { noremap = true, desc = "ChatGPT Fix Bugs" })
    vim.keymap.set("n", "<leader>ad", "<cmd>ChatGPTRun docstring<cr>", { noremap = true, desc = "ChatGPT Docstring" })
    vim.keymap.set("n", "<leader>ar", "<cmd>ChatGPTRun code_readability_analysis<cr>", { noremap = true, desc = "ChatGPT Code Readability Analysis" })
    vim.keymap.set("n", "<leader>ag", "<cmd>ChatGPTRun grammar_correction<cr>", { noremap = true, desc = "ChatGPT Grammar Correction" })
    vim.keymap.set("n", "<leader>as", "<cmd>ChatGPTRun summarize<cr>", { noremap = true, desc = "ChatGPT Summarize" })
    vim.keymap.set("n", "<leader>an", "<cmd>ChatGPTRun translate<cr>", { noremap = true, desc = "ChatGPT Translate" })
    vim.keymap.set("n", "<leader>ak", "<cmd>ChatGPTRun keywords<cr>", { noremap = true, desc = "ChatGPT Keywords" })
end

return { init = init }


