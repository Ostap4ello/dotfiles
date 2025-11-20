return {
    { -- Autocompletion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets", -- todo
            "saadparwaiz1/cmp_luasnip",

            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",

            "hrsh7th/cmp-path",
            -- "hrsh7th/cmp-calc",
            -- "octaltree/cmp-look",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})

            cmp.setup({
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
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),

                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    -- Accept ([y]es) the completion.
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),

                    -- If you prefer more traditional completion keymaps,
                    -- you can uncomment the following lines
                    --['<CR>'] = cmp.mapping.confirm { select = true },
                    --['<Tab>'] = cmp.mapping.select_next_item(),
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
            })
        end,
    },
}
