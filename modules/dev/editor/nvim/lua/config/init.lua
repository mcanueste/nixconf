local function init()
    vim.g.mapleader = " "
    require("config.options").init()
    require("config.autocommands").init()
    require("config.maps").init()
    require("config.mini").init()

    require("config.tools").init()
    require("config.git").init()
    require("config.treesitter").init()
    require("config.lsp").init()
    require("config.dap").init()
    require("config.floats").init()
    require("config.ai").init()
    require("config.notes").init()

    require("config.colorscheme").init()
    require("config.statusline").init()
    require("config.whichkey").init()
end

return { init = init }
