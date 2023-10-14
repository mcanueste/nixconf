local dapvirt = require("nvim-dap-virtual-text")
local whichkey = require("which-key")
local dapgo = require("dap-go")
local dapui = require("dapui")
local dap = require("dap")

---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
    config = vim.deepcopy(config)
    ---@cast args string[]
    config.args = function()
        local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
        return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
    end
    return config
end

local function init()
    -- Debugger for nvim
    -- https://github.com/mfussenegger/nvim-dap/
    -- https://github.com/rcarriga/nvim-dap-ui/
    -- https://github.com/theHamsta/nvim-dap-virtual-text/
    -- https://github.com/mfussenegger/nvim-dap-python/
    -- https://github.com/leoluz/nvim-dap-go/

    ------------------------------------------ Setup DAP Keymaps
    whichkey.register({ d = { name = "dap" } }, { prefix = "<leader>" })

    vim.keymap.set("n", "<leader>dc", function()
        -- dap.continue({ before = get_args })
        dap.continue()
    end, { desc = "Continue" })
    vim.keymap.set("n", "<leader>dd", function()
        dap.toggle_breakpoint()
    end, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>db", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Set Breakpoint Condition" })
    vim.keymap.set("n", "<leader>dm", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end, { desc = "Set Breakpoint Message" })
    vim.keymap.set("n", "<leader>dr", function()
        dap.repl.open()
    end, { desc = "REPL" })
    vim.keymap.set("n", "<leader>dp", function()
        dap.pause()
    end, { desc = "Pause" })
    vim.keymap.set("n", "<leader>dt", function()
        dap.terminate()
    end, { desc = "Terminate" })
    vim.keymap.set("n", "<leader>ds", function()
        dap.step_over()
    end, { desc = "Step Over" })
    vim.keymap.set("n", "<leader>di", function()
        dap.step_into()
    end, { desc = "Step Into" })
    vim.keymap.set("n", "<leader>do", function()
        dap.step_out()
    end, { desc = "Step Out" })
    -- vim.keymap.set("n", "<leader>dg", function()
    --     dap.goto_()
    -- end, { desc = "Go to line (no execute)" })
    -- vim.keymap.set("n", "<leader>dl", function()
    --     dap.run_last()
    -- end, { desc = "Run Last" })
    -- vim.keymap.set("n", "<leader>dC", function()
    --     dap.run_to_cursor()
    -- end, { desc = "Run to Cursor" })
    -- vim.keymap.set("n", "<leader>dj", function()
    --     dap.down()
    -- end, { desc = "Down" })
    -- vim.keymap.set("n", "<leader>dk", function()
    --     dap.up()
    -- end, { desc = "Up" })
    vim.keymap.set("n", "<leader>dw", function()
        require("dap.ui.widgets").hover()
    end, { desc = "Widgets" })

    ------------------------------------------ Setup DAP UI
    dapui.setup()
    vim.keymap.set("n", "<leader>du", function()
        dapui.toggle()
    end, { desc = "DAP UI Toggle" })
    vim.keymap.set({ "n", "v" }, "<leader>de", function()
        dapui.eval()
    end, { desc = "Eval" })
    -- Automatically open/close dap ui
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    ------------------------------------------ Setup DAP virtual text
    dapvirt.setup()

    ------------------------------------------ Setup DAP Go
    dapgo.setup()
    vim.keymap.set("n", "<leader>dgt", function()
        dapgo.debug_test()
    end, { desc = "Go Debug Test" })
    vim.keymap.set("n", "<leader>dgT", function()
        dapgo.debug_last_test()
    end, { desc = "Go Debug Last Test" })

    -- TODO: setup debugpy and nvim-dap-python
end

return { init = init }
