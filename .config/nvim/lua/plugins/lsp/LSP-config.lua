return {
    { "mfussenegger/nvim-jdtls", dependencies = { "hrsh7th/nvim-cmp" } },
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    { "j-hui/fidget.nvim", opts = {} }, -- Useful status updates for LSP.
    {
        "folke/neodev.nvim",
        config = function()
            require("neodev").setup({
                library = {
                    library = { plugins = { "nvim-dap-ui" }, types = true },
                    vimruntime = true, -- runtime files
                    plugins = true, -- installed plugins
                    config = true, -- config files
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim", -- Corrected: "mason-org/mason.nvim" is usually "williamboman/mason.nvim"
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            -- "nvim-java/nvim-java", -- Keep commented or remove if not using nvim-java yet
        },
        config = function()
            -- require("java").setup() -- Keep commented or remove if not using nvim-java yet

            local capabilities = vim.lsp.protocol.make_client_capabilities() -- Initialize with the capabilities that the NVIM is able to do
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            local servers = {
                lua_ls = {
                    root_dir = vim.fn.getcwd(),
                    cmd = { "lua-language-server", "--force-accept-workspace" }, -- Your custom cmd
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                            runtime = {
                                version = "LuaJIT",
                            },
                            workspace = {
                                checkThirdParty = false,
                            },
                            telemetry = {
                                enable = false, -- Recommended to disable for privacy
                            },
                        },
                    },
                },
                jdtls = {
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
                    -- cmd = { "texlab" },
                    -- filetypes = { "tex", "plaintex", "bib" },
                    -- root_markers = { ".git", ".latexmkrc", "latexmkrc", ".texlabroot", "texlabroot", "Tectonic.toml" },
                    settings = {
                        texlab = {
                            rootDirectory = nil,
                            build = {
                                executable = "latexmk",
                                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-output-directory=.build", "%f" },
                                onSave = false,
                                forwardSearchAfter = false,
                            },
                            forwardSearch = {
                                executable = nil,
                                args = {},
                            },
                            chktex = {
                                onOpenAndSave = true,
                                onEdit = true,
                            },
                            diagnosticsDelay = 300,
                            latexFormatter = "latexindent",
                            latexindent = {
                                ["local"] = nil, -- local is a reserved keyword
                                modifyLineBreaks = false,
                            },
                            bibtexFormatter = "texlab",
                            formatterLineLength = 80,
                        },
                    },
                },

                ["bash-language-server"] = {},

                clangd = {
                    root_dir = vim.fn.getcwd(),
                    cmd = { "clangd", "--header-insertion=never" },
                },
                pyright = {},
            }
            local misc = {
                "asmfmt",
                "black",
                "stylua",
                "beautysh",
                "shfmt",
                "jq",
                "flake8",
                "clang-format",
            }

            local ensure_installed = vim.tbl_keys(servers or {})
            ensure_installed = vim.list_extend(ensure_installed, misc)

            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name, default_lsp_config)
                        local server_opts = servers[server_name] or {}

                        default_lsp_config.capabilities =
                            vim.tbl_deep_extend("force", default_lsp_config.capabilities or {}, capabilities)

                        local merged_config = vim.tbl_deep_extend("force", default_lsp_config, server_opts)

                        require("lspconfig")[server_name].setup(merged_config)
                    end,
                },
                ensure_installed = {},
                automatic_installation = false,
            })

            for name, setting in pairs(servers) do
                vim.lsp.config(name, setting)
                vim.lsp.enable(name)
            end

            -- Keymaps for LSP
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    vim.keymap.set("n", "<leader>cd", function()
                        require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" })
                    end, { desc = "[C]ode Goto [d]efinition" })
                    vim.keymap.set(
                        "n",
                        "<leader>cr",
                        require("telescope.builtin").lsp_references,
                        { desc = "[C]ode Goto [r]eferences" }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>cI",
                        require("telescope.builtin").lsp_implementations,
                        { desc = "[C]ode Goto [I]mplementation" }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>cD",
                        require("telescope.builtin").lsp_type_definitions,
                        { desc = "[C]ode Goto Type [D]efinition" }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>cS",
                        require("telescope.builtin").lsp_document_symbols,
                        { desc = "[C]ode Document [S]ymbols" }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>cs",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        { desc = "[C]ode Dynamic [s]ymbols" }
                    )
                    vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename Object" })
                    -- Execute a code action, usually your cursor needs to be on top of an error or a suggestion from your LSP for this to activate.
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction (hint)" })

                    vim.keymap.set("n", "K", function()
                        vim.lsp.buf.hover()
                    end, { desc = "Hover Documentation" })

                    vim.keymap.set("n", "L", function()
                        vim.diagnostic.open_float()
                    end, { desc = "Show Line Diagnostics" })

                    -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        local highlight_augroup =
                            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                            end,
                        })
                    end

                    -- NOTE:

                    -- The following autocommand is used to enable inlay hints in your code, if the language server you are using supports them
                    -- This may be unwanted, since they displace some of your code
                    -- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                    -- 	map("<leader>th", function()
                    -- 		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled)
                    -- 	end, "[T]oggle Inlay [H]ints")
                    -- end
                end,
            })
        end,
    },
}
