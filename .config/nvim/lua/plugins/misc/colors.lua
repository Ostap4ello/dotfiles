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

            vim.api.nvim_create_user_command("ColorPicker", function()
                vim.print(
                    "Color picker binds:\n"
                        .. " i - change input format\n"
                        .. " o - change output format\n"
                        .. " h/l - change value of the row\n"
                        .. " H/M/L (0/50/100%), 1..9 (10..90%) - set value of the slider\n"
                        .. " q/<Enter> - cancel/save\n"
                )
            end, { range = true, desc = "CccPick + help" })
        end,
    },
}
