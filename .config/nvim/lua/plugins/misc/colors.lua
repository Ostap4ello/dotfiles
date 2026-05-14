return {
    {
        "uga-rosa/ccc.nvim",
        -- Ccc... commands
        config = function()
            local ccc = require("ccc")
            ccc.output.hex.setup({ uppercase = true })
            ccc.output.hex_short.setup({ uppercase = true })

            ccc.setup({
                highlighter = {
                    auto_enable = true,
                    lsp = true,
                },
            })
        end,
    },
}
