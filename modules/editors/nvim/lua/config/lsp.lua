local luasnipvscode = require("luasnip.loaders.from_vscode")
local symbols_outline = require("symbols-outline")
local lspconfig_util = require("lspconfig/util")
local rusttools = require("rust-tools")
local cmpnvim = require("cmp_nvim_lsp")
local neodev = require("neodev")
local lspconfig = require("lspconfig")
local whichkey = require("which-key")
local utils = require("config.utils")
local luasnip = require("luasnip")
local nls = require("null-ls")
local cmp = require("cmp")

local function init()
    -- LSP + Completion + Snippets + NullLS setup
    -- nvim-lspconfig: https://github.com/neovim/nvim-lspconfig -- Collection of configurations for built-in LSP client
    -- nvim-cmp: https://github.com/hrsh7th/nvim-cmp -- Autocompletion plugin
    -- cmp-nvim-lsp: https://github.com/hrsh7th/cmp-nvim-lsp -- LSP source for nvim-cmp
    -- cmp_luasnip: https://github.com/saadparwaiz1/cmp_luasnip -- Snippets source for nvim-cmp
    -- LuaSnip: https://github.com/L3MON4D3/LuaSnip -- Snippets plugin

    --------------------------------------------- Symbols outline
    symbols_outline.setup({
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = false,
        position = "right",
        relative_width = true,
        width = 25,
        auto_close = false,
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = true,
        preview_bg_highlight = "Pmenu",
        autofold_depth = nil,
        auto_unfold_hover = true,
        keymaps = { -- These keymaps can be a string or a table for multiple keys
            close = { "<Esc>", "q" },
            goto_location = "<Cr>",
            focus_location = "o",
            hover_symbol = "<C-space>",
            toggle_preview = "K",
            rename_symbol = "r",
            code_actions = "a",
            fold = "h",
            unfold = "l",
            fold_all = "W",
            unfold_all = "E",
            fold_reset = "R",
        },
        lsp_blacklist = {},
        symbol_blacklist = {},
        symbols = {
            File = { icon = "󰈔", hl = "@text.uri" },
            Namespace = { icon = "󰅪", hl = "@namespace" },
            Package = { icon = "󰏗", hl = "@namespace" },
            Array = { icon = "󰅪", hl = "@constant" },
            Event = { icon = "", hl = "@type" },
        },
    })

    ---------------------- Completion and diagnostics UI modifications
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
    vim.diagnostic.config({
        update_in_insert = false,
        underline = false,
        signs = true,
        virtual_text = true,
        severity_sort = true,
        float = {
            border = "rounded",
            source = "always",
        },
    })

    ---------------------- Load Snippets
    luasnipvscode.lazy_load()

    ---------------------- cmp setup
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
        -- Codeium = "",
    }
    -- local catppuccin_mocha = require("catppuccin.palettes").get_palette("mocha")
    -- vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { fg = catppuccin_mocha.sky })

    local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }
    cmp.setup({
        enabled = function()
            return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
        window = {
            completion = cmp.config.window.bordered({
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            }),
            documentation = cmp.config.window.bordered({
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            }),
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
                vim_item.menu = ({
                    -- codeium = "[AI]",
                    buffer = "[Buf]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[Snip]",
                    nvim_lua = "[Lua]",
                })[entry.source.name]
                return vim_item
            end,
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-y>"] = cmp.mapping.confirm({ select = true }),
            ["<C-e>"] = cmp.mapping.abort(),

            ["<Up>"] = cmp.mapping.select_prev_item(cmp_select_opts),
            ["<Down>"] = cmp.mapping.select_next_item(cmp_select_opts),
            ["<C-p>"] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_prev_item(cmp_select_opts)
                else
                    cmp.complete()
                end
            end),
            ["<C-n>"] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_next_item(cmp_select_opts)
                else
                    cmp.complete()
                end
            end),
            ["<Tab>"] = cmp.mapping(function(fallback)
                local col = vim.fn.col(".") - 1
                if cmp.visible() then
                    cmp.select_next_item(cmp_select_opts)
                elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                    fallback()
                else
                    cmp.complete()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item(cmp_select_opts)
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<C-u>"] = cmp.mapping.scroll_docs(-5),
            ["<C-d>"] = cmp.mapping.scroll_docs(5),
            ["<C-f>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-b>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
            -- { name = "codeium" },
            { name = "nvim_lsp" },
            { name = "nvim_lsp_signature_help" },
            { name = "nvim_lua" }, -- FIXME: might not need this anymore due to neodev.nvim
            { name = "luasnip" },
            { name = "path" },
        }, {
            { name = "buffer", keyword_length = 3 },
        }),
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
        }, {
            { name = "buffer" },
        }),
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
    })

    -- Completions on dap UI
    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
            { name = "dap" },
        },
    })

    -- Emoji completions on markdown
    cmp.setup.filetype({ "markdown" }, {
        sources = {
            { name = "emoji" },
        },
    })

    -------------------------------------------- LSP
    -- Add additional capabilities supported by nvim-cmp
    local capabilities = cmpnvim.default_capabilities()

    ---------------------- Lua
    neodev.setup({
        library = {
            -- you can also specify the list of plugins to make available as a workspace library
            plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim", "nvim-dap-ui" },
        },
        override = function(root_dir, library)
            if root_dir:find("/etc/nixos", 1, true) == 1 or root_dir:find("/nix/store", 1, true) == 1 then
                library.enabled = true
                library.plugins = true
            end
        end,
    })

    lspconfig.lua_ls.setup({
        settings = {
            Lua = {
                telemetry = { enable = false },
                format = { enable = false },
                completion = {
                    callSnippet = "Replace",
                },
            },
        },
    })

    ---------------------- bash
    lspconfig.bashls.setup({})

    ---------------------- docker
    lspconfig.dockerls.setup({})
    -- lspconfig.docker_compose_language_service.setup({
    --     filetypes = { "yaml.docker-compose" }, -- TOOD: setup ft?
    -- })

    ---------------------- terraform
    lspconfig.terraformls.setup({})

    ---------------------- Nix
    lspconfig.nil_ls.setup({
        capabilities = capabilities,
        autostart = true,
        settings = {
            ["nil"] = {
                formatting = {
                    command = { "alejandra" },
                },
            },
        },
    })

    ---------------------- Python
    -- Setup python lsp
    lspconfig.ruff_lsp.setup({})
    lspconfig.pyright.setup({}) -- remove if duplicates with ruff

    ---------------------- Go
    lspconfig.gopls.setup({
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = lspconfig_util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
            gopls = {
                staticcheck = true,
                usePlaceholders = true,
                completeUnimported = true,
                experimentalPostfixCompletions = true,
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
            },
        },
        init_options = {
            usePlaceholders = true,
        },
    })
    lspconfig.golangci_lint_ls.setup({})

    ---------------------- Rust
    -- Setup rust_analyzer via rust-tools.nvim
    rusttools.setup({
        server = {
            capabilities = capabilities,
        },
    })

    ---------------------- HTMX
    -- lspconfig.htmx.setup() -- Currently buggy with the LSP version

    -- TODO: Setup jsonls https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#jsonls

    -- LspAttach mappings
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
            -- vim.keymap.set("n", "<space>lq", vim.diagnostic.setloclist) TODO: decide later

            -- Enable completion triggered by <c-x><c-o>
            -- Also see: https://github.com/hrsh7th/nvim-cmp/wiki/Language-Server-Specific-Samples#golang-gopls
            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
            vim.bo[ev.buf].tagfunc = "v:lua.vim.lsp.tagfunc"
            vim.bo[ev.buf].formatexpr = "v:lua.vim.lsp.formatexpr()"

            local function opts(desc)
                return { buffer = ev.buf, desc = desc }
            end

            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover [LSP]"))
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Definition [LSP]"))
            vim.keymap.set("n", "gD", "<cmd>TroubleToggle lsp_definitions<cr>", { desc = "Definitions [LSP]" })
            vim.keymap.set("n", "gc", vim.lsp.buf.declaration, opts("Decleration [LSP]"))
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Implementation [LSP]"))
            vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { desc = "Implementations [LSP]" })
            -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("References")) -- Using Trouble is better for this
            vim.keymap.set("n", "gr", "<cmd>TroubleToggle lsp_references<cr>", { desc = "References [LSP]" })
            -- I don't use tabs so overriding gt (go to next tab)
            vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts("Type Definition [LSP]"))
            vim.keymap.set(
                "n",
                "gT",
                "<cmd>TroubleToggle lsp_type_definitions<cr>",
                { desc = "Type Definitions [LSP]" }
            )
            -- Override default gs (sleep nvim for seconds)
            vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts("Signature [LSP]"))

            whichkey.register({ l = { name = "lsp" } }, { prefix = "<leader>" })
            vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts("Rename"))
            vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts("Code Action"))
            vim.keymap.set("n", "<leader>ll", function()
                vim.lsp.buf.format({ async = true })
            end, opts("Format"))
            vim.keymap.set("n", "<space>ld", vim.diagnostic.open_float, opts("Line Diagnostics"))
            vim.keymap.set(
                "n",
                "<leader>lD",
                "<cmd>TroubleToggle document_diagnostics<cr>",
                { desc = "Document Diagnostics" }
            )
            vim.keymap.set("n", "<leader>lc", "<cmd>Telescope lsp_incoming_calls<CR>", { desc = "Incoming Calls" })
            vim.keymap.set("n", "<leader>lC", "<cmd>Telescope lsp_outgoing_calls<CR>", { desc = "Outgoing Calls" })
            vim.keymap.set("n", "<leader>ls", "<cmd>SymbolsOutline<CR>", { desc = "Symbols Outline" })
            vim.keymap.set(
                "n",
                "<leader>lS",
                utils.telescope("lsp_document_symbols", {
                    symbols = {
                        "Class",
                        "Function",
                        "Method",
                        "Constructor",
                        "Interface",
                        "Module",
                        "Struct",
                        "Trait",
                        "Field",
                        "Property",
                    },
                }),
                { desc = "Symbols" }
            )

            -- Workspace keymaps
            whichkey.register({ lw = { name = "workspace" } }, { prefix = "<leader>" })
            vim.keymap.set("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, opts("Workspace add"))
            vim.keymap.set("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, opts("Workspace remove"))
            vim.keymap.set("n", "<leader>lwl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts("Workspace list"))
            vim.keymap.set(
                "n",
                "<leader>lwd",
                "<cmd>TroubleToggle workspace_diagnostics<cr>",
                { noremap = true, desc = "Workspace Diagnostics" }
            )
            vim.keymap.set(
                "n",
                "<leader>lws",
                "<cmd>Telescope lsp_workspace_symbols<CR>",
                { noremap = true, desc = "Workspace Symbols" }
            )
            vim.keymap.set(
                "n",
                "<leader>lwS",
                "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
                { noremap = true, desc = "Dynamic Workspace Symbols" }
            )
        end,
    })

    -- Setup ansible lsp
    -- TODO: setup some functions for `yaml.ansible` ft?
    -- lspconfig.ansiblels.setup({
    --     ansible = {
    --         ansible = {
    --             path = "ansible",
    --         },
    --         executionEnvironment = {
    --             enabled = false,
    --         },
    --         python = {
    --             interpreterPath = "python",
    --         },
    --         validation = {
    --             enabled = true,
    --             lint = {
    --                 enabled = true,
    --                 path = "ansible-lint",
    --             },
    --         },
    --     },
    -- })

    -- Setup yaml lsp
    -- TODO: schemas don't seem to work?
    -- lspconfig.yamlls.setup({
    --     redhat = { telemetry = { enabled = false } },
    --     settings = {
    --         yaml = {
    --             schemaStore = { enable = false },
    --             schemas = schemastore.yaml.schemas(),
    --         },
    --     },
    -- })

    --------------------------------------------- Null-LS
    nls.setup({
        sources = {
            -- lua
            nls.builtins.formatting.stylua,

            -- bash
            nls.builtins.formatting.beautysh,
            nls.builtins.formatting.shellharden,
            nls.builtins.code_actions.shellcheck,

            -- docker
            nls.builtins.diagnostics.hadolint,

            -- terraform
            nls.builtins.formatting.terraform_fmt,
            nls.builtins.diagnostics.terraform_validate,
            nls.builtins.diagnostics.tfsec,

            -- python
            nls.builtins.formatting.black,
            nls.builtins.formatting.ruff,
            nls.builtins.formatting.djhtml,
            nls.builtins.diagnostics.mypy,

            -- go
            -- nls.builtins.formatting.gofumpt,
            -- nls.builtins.code_actions.golines,
            -- nls.builtins.code_actions.gomodifytags,
            -- nls.builtins.code_actions.impl,
            -- nls.builtins.code_actions.refactoring, -- install if needed

            -- yaml
            -- nls.builtins.formatting.yamlfmt,

            -- nls.builtins.formatting.prettier, -- generic formatting
        },
    })
end

return { init = init }
