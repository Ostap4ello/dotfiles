return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "s1n7ax/nvim-window-picker",
        },
        lazy = false, -- neo-tree will lazily load itself
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    filtered_items = {
                        visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
                        hide_dotfiles = false,
                        hide_gitignored = true,
                    },
                },
            })
            vim.keymap.set("n", "<leader>b", function()
                vim.cmd("Neotree toggle")
            end, { desc = "Toggle Nvim Tree" })
        end,
    },
    {
        "s1n7ax/nvim-window-picker",
        config = function()
            require("window-picker").setup({})

            vim.keymap.set("n", "<leader>W", function()
                -- vim.cmd("wincmd =")
                local picked_window_id = require("window-picker").pick_window({
                    include_current_win = true,
                }) or vim.api.nvim_get_current_win()
                vim.api.nvim_set_current_win(picked_window_id)
            end, { desc = "Pick a window" })
        end,
    },
}
