local function init()
    -- TODO breadcrumbs instead of context?
    -- TODO call trees
    -- TODO symbols on the right instead
    -- TODO setup a different chatgpt client?
    -- TODO terminals?
    vim.g.mapleader = " "
    require("config.options").init()
    require("config.autocommands").init()
    require("config.maps").init()
    require("config.colorscheme").init()
    require("config.statusline").init()
    require("config.mini").init()
    require("config.oil").init()
    require("config.telescope").init()
    require("config.harpoon").init()
    require("config.gitsigns").init()
    require("config.treesitter").init()
    require("config.floats").init()
    require("config.cmp").init()
    require("config.autopairs").init()
    require("config.lsp").init()
    require("config.null").init()
    require("config.dap").init()
    require("config.trouble").init()
    require("config.copilot").init()
    require("config.ai").init()
    require("config.notes").init()
    require("config.whichkey").init()
end

return { init = init }
