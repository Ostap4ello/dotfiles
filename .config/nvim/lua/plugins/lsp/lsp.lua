return {
    { "j-hui/fidget.nvim", opts = {} },
    { "mfussenegger/nvim-jdtls", dependencies = { "hrsh7th/nvim-cmp" } },
    {
        "folke/neodev.nvim",
        config = function()
            require("neodev").setup({
                library = {
                    library = { plugins = { "nvim-dap-ui" }, types = true },
                    vimruntime = true,
                    plugins = true,
                    config = true,
                },
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- LSP Automation Tools
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Autocompletion Monolith Engine
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            -- 1. Initialize Mason
            require("mason").setup()

            -- 2. Setup Autocompletion (nvim-cmp)
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local cmp_opts = {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                completion = { completeopt = "menu,menuone,noinsert" },

                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_next_item(),
                    ["<C-S-p>"] = cmp.mapping.select_prev_item(),

                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    -- Accept ([y]es) the completion.
                    ["<S-CR>"] = cmp.config.disable,

                    -- If you prefer more traditional completion keymaps,
                    -- you can uncomment the following lines
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    -- ['<Tab>'] = cmp.mapping.select_next_item(),
                    --['<S-Tab>'] = cmp.mapping.select_prev_item(), for each

                    -- Manually trigger a completion from nvim-cmp.
                    ["<C-Space>"] = cmp.mapping.complete({}),

                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "copilot", priority = 8 }, -- Copilot
                    { name = "nvim_lsp", priority = 8 }, -- cmp-nvim-lsp
                    { name = "luasnip", priority = 8 }, -- LuaSnip
                    { name = "vim-dadbod-completion", priority = 8 },
                    { name = "path", priority = 2 },
                    { name = "buffer", priority = 1 }, -- cmp-buffer
                    -- { name = "calc", priority = 1 },
                    -- { name = "look", priority = 1 },
                },
            }

            cmp.setup(cmp_opts)

            -- 3. Unified Server Configuration Table (Using modern vim.lsp.config options)
            local servers = {
                pyright = {},
                bashls = {},

                -- Custom rule for Termux: use system-wide clangd binary
                clangd = {
                    cmd = { "clangd", "--header-insertion=never" },
                    -- WARN: fix for termux
                    -- needs clang installed system-wide
                    mason = false,
                },

                lua_ls = {
                    cmd = { "lua-language-server", "--force-accept-workspace" },
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            runtime = { version = "LuaJIT" },
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                        },
                    },
                    -- WARN: fix for termux
                    -- needs lua-language-server installed system-wide
                    mason = false,
                },

                jdtls = {
                    root_dir = function(fname)
                        return vim.fs.root(fname, { "mvnw", "gradlew", "pom.xml", "build.gradle", ".git" })
                    end,
                    settings = {
                        java = {
                            configuration = {
                                runtimes = {
                                    { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk/" },
                                    { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk/" },
                                    { name = "JavaSE-25", path = "/usr/lib/jvm/java-25-openjdk/" },
                                },
                            },
                        },
                    },
                },

                texlab = {
                    settings = {
                        texlab = {
                            build = {
                                executable = "latexmk",
                                args = {
                                    "-pdf",
                                    "-interaction=nonstopmode",
                                    "-synctex=1",
                                    "-output-directory=.build",
                                    "%f",
                                },
                            },
                            chktex = { onOpenAndSave = true, onEdit = true },
                        },
                    },
                    -- WARN: fix for termux
                    -- needs texlab installed system-wide
                    mason = false,
                },
            }

            -- External standalone tools (formatters and linters)
            local formatters_and_linters = {
                "asmfmt",
                "black",
                -- WARN: fix for termux
                -- requires these installed system-wide
                -- "stylua",
                -- "beautysh",
                "shfmt",
                "jq",
                "flake8",
                "clang-format",
                "prettier",
            }

            -- Initialize autocomplete capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            -- 4. Intelligent Filtering for Mason Installation Queue
            local lsp_to_install = {}
            for server_name, server_opts in pairs(servers) do
                if server_opts.mason ~= false then
                    table.insert(lsp_to_install, server_name)
                end
            end

            local all_tools = vim.list_extend(lsp_to_install, formatters_and_linters)
            require("mason-tool-installer").setup({ ensure_installed = all_tools })

            -- 5. Modern Neovim 0.11+ Setup Loop (Completely removes old require('lspconfig').setup)
            for server_name, server_opts in pairs(servers) do
                -- Deep copy settings to avoid mutating the original table
                local final_opts = vim.deepcopy(server_opts)
                final_opts.mason = nil -- Strip out our custom flag

                -- Merge global capabilities with server-specific ones
                final_opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, final_opts.capabilities or {})

                -- The NEW Neovim 0.11+ Native Standard way:
                -- 1. Mutate/Extend the template configuration in native registry
                vim.lsp.config(server_name, final_opts)

                -- 2. Dynamically enable/start the server based on filetypes
                vim.lsp.enable(server_name)
            end

            -- 6. Client Keymaps (LspAttach event)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(mode, l, r, desc)
                        vim.keymap.set(mode, l, r, { buffer = event.buf, desc = desc })
                    end

                    map("n", "<leader>cd", function()
                        require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" })
                    end, "[C]ode Goto [d]efinition")
                    map(
                        "n",
                        "<leader>cr",
                        require("telescope.builtin").lsp_references,
                        "[C]ode Goto [r" .. "]eferences"
                    )
                    map(
                        "n",
                        "<leader>cI",
                        require("telescope.builtin").lsp_implementations,
                        "[C]ode Goto [I]mplementation"
                    )
                    map(
                        "n",
                        "<leader>cD",
                        require("telescope.builtin").lsp_type_definitions,
                        "[C]ode Goto Type [D]efinition"
                    )
                    map(
                        "n",
                        "<leader>cS",
                        require("telescope.builtin").lsp_document_symbols,
                        "[C]ode Document [S]ymbols"
                    )
                    map(
                        "n",
                        "<leader>cs",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[C]ode Dynamic [s]ymbols"
                    )
                    map("n", "<leader>cR", vim.lsp.buf.rename, "[C]ode [R]ename Object")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction (hint)")
                    map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
                    map("n", "L", vim.diagnostic.open_float, "Show Line Diagnostics")

                    -- Document word highlighting trigger on cursor hold
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        local highlight_augroup =
                            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd(
                            { "CursorHold", "CursorHoldI" },
                            { buffer = event.buf, group = highlight_augroup, callback = vim.lsp.buf.document_highlight }
                        )
                        vim.api.nvim_create_autocmd(
                            { "CursorMoved", "CursorMovedI" },
                            { buffer = event.buf, group = highlight_augroup, callback = vim.lsp.buf.clear_references }
                        )
                    end
                end,
            })

            -- 7. Document autocompilation triggers for Texlab
            local aucmd_texlab_id = nil
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "*.tex",
                group = vim.api.nvim_create_augroup("TexlabPreviewerGroup", { clear = true }),
                callback = function()
                    vim.api.nvim_buf_create_user_command(0, "TexlabStartPreview", function()
                        aucmd_texlab_id = vim.api.nvim_create_autocmd("BufWritePost", {
                            buffer = 0,
                            callback = function()
                                vim.cmd("LspTexlabBuild")
                            end,
                        })
                    end, {})
                    vim.api.nvim_buf_create_user_command(0, "TexlabStopPreview", function()
                        if aucmd_texlab_id then
                            vim.api.nvim_del_autocmd(aucmd_texlab_id)
                            aucmd_texlab_id = nil
                        end
                    end, {})
                end,
            })
        end,
    },
}
