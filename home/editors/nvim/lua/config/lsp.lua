local luasniploader = require("luasnip.loaders.from_vscode")
local cmpnvim = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")
local utils = require("config.utils")
local luasnip = require("luasnip")
local nls = require("null-ls")
local cmp = require("cmp")

local function init()
    ----------------------------------------------- LSP
    local lsp_defaults = lspconfig.util.default_config -- Extend client capabilities
    lsp_defaults.capabilities = vim.tbl_deep_extend("force", lsp_defaults.capabilities, cmpnvim.default_capabilities())

    -- Setup nix lsp
    lspconfig.nil_ls.setup({
        autostart = true,
        settings = {
            ["nil"] = {
                formatting = {
                    command = { "alejandra" },
                },
            },
        },
    })

    -- Setup lua lsp
    lspconfig.lua_ls.setup({
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                telemetry = { enable = false },
                format = { enable = false }, -- use stylelua
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
            },
        },
    })

    -- Setup go lsp
    lspconfig.gopls.setup({})
    lspconfig.golangci_lint_ls.setup({})

    -- Setup python lsp
    -- lspconfig.ruff_lsp.setup({})
    -- lspconfig.pyright.setup({}) -- remove if duplicates with ruff

    -- Setup bash lsp
    lspconfig.bashls.setup({})

    -- Setup docker lsp
    -- lspconfig.dockerls.setup({})
    -- lspconfig.docker_compose_language_service.setup({
    --     filetypes = { "yaml.docker-compose" }, -- TOOD: setup ft?
    -- })

    -- Setup terraform lsp
    -- lspconfig.terraformls.setup({})

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

    -- lazy load snippets
    luasniploader.lazy_load()

    local cmp_select_opts = { behavior = cmp.SelectBehavior.Select } -- setup completions
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        sources = {
            { name = "nvim_lsp", keyword_length = 1 },
            { name = "buffer", keyword_length = 3 },
            { name = "luasnip", keyword_length = 2 },
            { name = "path" },
        },
        window = { documentation = cmp.config.window.bordered() },
        formatting = {
            fields = { "abbr", "menu", "kind" },
            format = function(entry, item)
                local short_name = {
                    nvim_lua = "nvim",
                    nvim_lsp = "lsp",
                    luasnip = "snip",
                    buffer = "buff",
                    path = "path",
                }
                local menu_name = short_name[entry.source.name] or entry.source.name
                item.menu = string.format("[%s]", menu_name)
                return item
            end,
        },
        mapping = {
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
        },
    })

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
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    vim.api.nvim_create_autocmd("LspAttach", { -- Setup keybindings
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
            require("which-key").register({ l = { name = "lsp" } }, { prefix = "<leader>" })
            require("which-key").register({ lw = { name = "workspace" } }, { prefix = "<leader>" })
            local function opts(desc)
                return { buffer = ev.buf, desc = desc }
            end

            -- vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, opts("Definition")) -- using trouble
            vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, opts("Decleration"))
            vim.keymap.set("n", "<leader>lk", vim.lsp.buf.signature_help, opts("Signature"))
            vim.keymap.set("n", "<leader>lK", vim.lsp.buf.hover, opts("Documentation"))
            -- vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, opts("References")) -- using trouble
            vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, opts("Rename buffer"))
            -- vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, opts("Implementation")) -- using telescope
            -- vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, opts("Type definition")) -- using trouble
            vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts("Code action"))
            vim.keymap.set("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, opts("Workspace add"))
            vim.keymap.set("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, opts("Workspace remove"))
            vim.keymap.set("n", "<leader>lwl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts("Workspace list"))
            vim.keymap.set("n", "<leader>ll", function()
                vim.lsp.buf.format({ async = true })
            end, opts("Format"))

            -------------------------------------------- Trouble keymaps
            vim.keymap.set(
                "n",
                "<leader>ld",
                "<cmd>TroubleToggle lsp_definitions<cr>",
                { noremap = true, desc = "Definitions" }
            )
            vim.keymap.set(
                "n",
                "<leader>lr",
                "<cmd>TroubleToggle lsp_references<cr>",
                { noremap = true, desc = "References" }
            )
            vim.keymap.set(
                "n",
                "<leader>lt",
                "<cmd>TroubleToggle lsp_type_definitions<cr>",
                { noremap = true, desc = "Type Definitions" }
            )
            vim.keymap.set(
                "n",
                "<leader>lg",
                "<cmd>TroubleToggle document_diagnostics<cr>",
                { noremap = true, desc = "Document Diagnostics" }
            )
            vim.keymap.set(
                "n",
                "<leader>lG",
                "<cmd>TroubleToggle workspace_diagnostics<cr>",
                { noremap = true, desc = "Workspace Diagnostics" }
            )

            -------------------------------------------- Telescope
            vim.keymap.set(
                "n",
                "<leader>li",
                "<cmd>Telescope lsp_implementations<cr>",
                { noremap = true, desc = "Implementations" }
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
            vim.keymap.set(
                "n",
                "<leader>lc",
                "<cmd>Telescope lsp_incoming_calls<CR>",
                { noremap = true, desc = "Incoming Calls" }
            )
            vim.keymap.set(
                "n",
                "<leader>lC",
                "<cmd>Telescope lsp_outgoing_calls<CR>",
                { noremap = true, desc = "Outgoing Calls" }
            )
            vim.keymap.set(
                "n",
                "<leader>ls",
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
                { noremap = true, desc = "Symbols" }
            )
        end,
    })

    --------------------------------------------- Null-LS
    nls.setup({
        sources = {
            -- lua
            nls.builtins.formatting.stylua,

            -- go
            -- nls.builtins.formatting.gofumpt,
            -- nls.builtins.formatting.goimports,
            -- nls.builtins.code_actions.gomodifytags,
            -- nls.builtins.code_actions.impl,
            -- nls.builtins.code_actions.golines, -- install if needed
            -- nls.builtins.code_actions.refactoring, -- install if needed

            -- python
            -- nls.builtins.formatting.black,
            -- nls.builtins.formatting.ruff,
            -- nls.builtins.formatting.djhtml,
            -- nls.builtins.diagnostics.mypy,

            -- bash
            nls.builtins.formatting.beautysh,
            nls.builtins.formatting.shellharden,
            nls.builtins.code_actions.shellcheck,

            -- docker
            -- nls.builtins.diagnostics.hadolint,

            -- terraform
            -- nls.builtins.formatting.terraform_fmt,
            -- nls.builtins.diagnostics.terraform_validate,
            -- nls.builtins.diagnostics.tfsec,

            -- yaml
            -- nls.builtins.formatting.yamlfmt,

            -- nls.builtins.formatting.prettier, -- generic formatting
        },
    })
end

return { init = init }
