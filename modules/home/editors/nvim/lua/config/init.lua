local function init()
    require("config.basics").init()
    require("config.theme").init()
    require("config.maps").init()
    require("config.tools").init()
    require("config.vcs").init()
    require("config.treesitter").init()
    require("config.lsp").init()
    require("config.dap").init()
    require("config.floats").init()
    require("config.ai").init()
    require("config.notes").init()
end

return { init = init }
