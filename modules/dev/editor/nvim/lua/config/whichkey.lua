local function init()
    -- Setup which-key
    -- See: https://github.com/folke/which-key.nvim
    local whichkey = require("which-key")
    whichkey.setup()

    whichkey.register({ a = { name = "ai" } }, { prefix = "<leader>" })
    whichkey.register({ ac = { name = "copilot" } }, { prefix = "<leader>" })

    whichkey.register({ b = { name = "buffer" } }, { prefix = "<leader>" })
    whichkey.register({ e = { name = "edit" } }, { prefix = "<leader>" })

    whichkey.register({ l = { name = "lsp" } }, { prefix = "<leader>" })
    whichkey.register({ lw = { name = "workspace" } }, { prefix = "<leader>" })

    whichkey.register({ n = { name = "notes" } }, { prefix = "<leader>" })

    whichkey.register({ g = { name = "git" } }, { prefix = "<leader>" })
    whichkey.register({ gt = { name = "toggles" } }, { prefix = "<leader>" })

    whichkey.register({ t = { name = "toggle" } }, { prefix = "<leader>" })

    whichkey.register({ h = { name = "harpoon" } }, { prefix = "<leader>" })

    whichkey.register({ o = { name = "open" } }, { prefix = "<leader>" })

    whichkey.register({ f = { name = "find" } }, { prefix = "<leader>" })

    whichkey.register({ s = { name = "search" } }, { prefix = "<leader>" })

    local objects = {
        [" "] = "Whitespace",
        ["?"] = "User Prompt",
        _ = "Underscore",
        a = "Argument",
        c = "Class",
        f = "Function",
        o = "Block-Conditional-Loop",
        q = "Quote",
    }
    whichkey.register({ mode = { "o", "x" }, i = objects, a = objects })
end

return { init = init }
