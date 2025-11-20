return {
    {
        "lewis6991/gitsigns.nvim",
        dependencies = {
            "tanvirtin/vgit.nvim", -- better diffs for now
        },
        config = function()
            -- GitSigns
            local gitSigns = require("gitsigns")

            gitSigns.setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                -- -- signs = {
                -- --   add          = { text = '┃' },
                -- --   change       = { text = '┃' },
                -- --   delete       = { text = '_' },
                -- --   topdelete    = { text = '‾' },
                -- --   changedelete = { text = '~' },
                -- --   untracked    = { text = '┆' },
                -- -- },
                -- signs_staged = {
                --   add          = { text = '┃' },
                --   change       = { text = '┃' },
                --   delete       = { text = '_' },
                --   topdelete    = { text = '‾' },
                --   changedelete = { text = '~' },
                --   untracked    = { text = '┆' },
                -- },
                --   signs_staged_enable = true,
                --   signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
                --   numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
                --   linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
                --   word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
                --   watch_gitdir = {
                --     follow_files = true
                --   },
                --   auto_attach = true,
                --   attach_to_untracked = false,
                --   current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                --   current_line_blame_opts = {
                --     virt_text = true,
                --     virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                --     delay = 1000,
                --     ignore_whitespace = false,
                --     virt_text_priority = 100,
                --     use_focus = true,
                --   },
                --   current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
                --   sign_priority = 6,
                --   update_debounce = 100,
                --   status_formatter = nil, -- Use default
                --   max_file_length = 40000, -- Disable if file is longer than this (in lines)
                --   preview_config = {
                --     -- Options passed to nvim_open_win
                --     style = 'minimal',
                --     relative = 'cursor',
                --     row = 0,
                --     col = 1
                --   },
            })

            -- vim.keymap.set("n", "<leader>gb", function()
            -- 	gitSigns.blame_line()
            -- end, { desc = "[G]it show [b]lame" })
            vim.keymap.set("n", "<leader>gB", function()
                gitSigns.toggle_current_line_blame()
            end, { desc = "[G]it toggle live [B]lame" })
            vim.keymap.set("n", "<leader>ghn", function()
                gitSigns.next_hunk()
            end, { desc = "[G]it [h]unk [n]ext" })
            vim.keymap.set("n", "<leader>ghn", function()
                gitSigns.next_hunk()
            end, { desc = "[G]it [h]unk previous [N]" })
            vim.keymap.set("n", "<leader>ghp", function()
                gitSigns.preview_hunk()
            end, { desc = "[G]it [h]unk [p]review" })
            vim.keymap.set("n", "<leader>ghs", function()
                gitSigns.preview_hunk()
            end, { desc = "[G]it [h]unk [s]tage" })

            -- VGit
            local vgit = require("vgit")

            vgit.setup({
                settings = {
                    symbols = {
                        void = ".",
                        open = "",
                        close = "",
                    },
                },
            })

            vgit.toggle_diff_preference()
            vgit.toggle_live_blame()
            vgit.toggle_live_gutter() -- disables gutter as it is quite unstable

            vim.keymap.set("n", "<leader>gd", function()
                vgit.buffer_diff_preview()
            end, { desc = "[G]it show [d]iff" })
            vim.keymap.set("n", "<leader>gD", function()
                vgit.toggle_diff_preference()
            end, { desc = "[G]it toggle [D]iff inline/split view" })
            vim.keymap.set("n", "<leader>gb", function()
                vgit.buffer_blame_preview()
            end, { desc = "[G]it show [b]lame" })
        end,
    },
}
