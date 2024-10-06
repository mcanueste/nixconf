local function init()
    local home = vim.fn.expand("$HOME")
    local gp = require("gp")

    gp.setup({
        openai_api_key = { "cat", home .. "/.ssh/openai.key" },
        providers = {
            openai = {
                disable = false,
                endpoint = "https://api.openai.com/v1/chat/completions",
            },
        },

        agents = {
            {
                name = "ChatGPT4",
                chat = true,
                command = false,
                -- string with model name or table with model name and parameters
                model = { model = "gpt-4", temperature = 1.1, top_p = 1 },
                -- system prompt (use this to specify the persona/role of the AI)
                system_prompt = require("gp.defaults").chat_system_prompt,
            },
            {
                provider = "openai",
                name = "CodeGPT4",
                chat = false,
                command = true,
                -- string with model name or table with model name and parameters
                model = { model = "gpt-4", temperature = 0.8, top_p = 1 },
                -- system prompt (use this to specify the persona/role of the AI)
                system_prompt = require("gp.defaults").code_system_prompt,
            },
        },

        -- The banner shown at the top of each chat file.
        chat_template = require("gp.defaults").chat_template,
        -- if you want more real estate in your chat files and don't need the helper text
        -- chat_template = require("gp.defaults").short_chat_template,

        -- chat topic generation prompt
        chat_topic_gen_prompt = "Summarize the topic of our conversation above"
            .. " in two or three words. Respond only with those words.",
        -- chat topic model (string with model name or table with model name and parameters)

        -- local shortcuts bound to the chat buffer
        -- (be careful to choose something which will work across specified modes)
        chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
        chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
        chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
        chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },

        -- default search term when using :GpChatFinder
        chat_finder_pattern = "topic ",

        -- templates
        template_selection = "I have the following from {{filename}}:"
            .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
        template_rewrite = "I have the following from {{filename}}:"
            .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
            .. "\n\nRespond exclusively with the snippet that should replace the selection above.",
        template_append = "I have the following from {{filename}}:"
            .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
            .. "\n\nRespond exclusively with the snippet that should be appended after the selection above.",
        template_prepend = "I have the following from {{filename}}:"
            .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
            .. "\n\nRespond exclusively with the snippet that should be prepended before the selection above.",
        template_command = "{{command}}",

        whisper = {
            -- arecord is linux only, but has no cropping issues and is faster
            -- ffmpeg in the default configuration is macos only, but can be used on any platform
            -- whisper_rec_cmd = {"arecord", "-c", "1", "-f", "S16_LE", "-r", "48000", "-d", "3600", "rec.wav"},
            -- whisper_rec_cmd = {"ffmpeg", "-y", "-f", "avfoundation", "-i", ":0", "-t", "3600", "rec.wav"},
            rec_cmd = nil,
        },

        image = { secret = { "cat", home .. "/.ssh/openai.key" } },
    })

    vim.keymap.set("n", "<leader>at", "<cmd>GpChatToggle vsplit<cr>", { noremap = true, desc = "Toggle Chat" })

    vim.keymap.set("n", "<leader>af", "<cmd>GpChatFinder<cr>", { noremap = true, desc = "Find Chats" })

    vim.keymap.set("n", "<leader>aR", "<cmd>GpChatRespond<cr>", { noremap = true, desc = "Request New Response" })

    vim.keymap.set("n", "<leader>aD", "<cmd>GpChatDelete<cr>", { noremap = true, desc = "Delete Chat" })

    vim.keymap.set("n", "<leader>ac", "<cmd>GpContext vsplit<cr>", { noremap = true, desc = "Add to Context" })

    -- TODO: setup image and whisper later
    -- vim.keymap.set(
    --     "n",
    --     "<leader>ai",
    --     "<cmd>GpImage<cr>",
    --     { noremap = true, desc = "Add to Context" }
    -- )
end

return { init = init }
