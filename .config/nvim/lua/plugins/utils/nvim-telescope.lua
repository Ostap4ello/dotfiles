return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require("telescope.builtin")

        local settings = {
            defaults = {
                layout_strategy = "vertical",
                -- file_ignore_patterns = { "build/.*", "bin/.*" },
            },
        }
        -- require("telescope").extensions.live_grep_args.live_grep_args({
        -- 	vimgrep_arguments = {
        -- 		"rg",
        -- 		"--color=never",
        -- 		"--no-heading",
        -- 		"--with-filename",
        -- 		"--line-number",
        -- 		"--column",
        -- 		"--smart-case",
        -- 		"--no-ignore", -- added this, the rest above are defaults
        -- 	},
        -- })

        -- Search section
        vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
        vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
        vim.keymap.set("n", "<leader>sf", function()
            builtin.find_files({ no_ignore = true })
        end, { desc = "[S]earch [F]iles" })
        vim.keymap.set("n", "<leader>sg", function()
            builtin.live_grep({ no_ignore = true })
        end, { desc = "[S]earch by [G]rep" })
        vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
        vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        vim.keymap.set("n", "<leader>so", function()
            builtin.live_grep({
                grep_open_files = true,
                prompt_title = "Live Grep in Open Files",
            })
        end, { desc = "[S]earch in [O]pen Files" })
        vim.keymap.set("n", "<leader>sn", function()
            builtin.find_files({ cwd = vim.fn.stdpath("config") })
        end, { desc = "[S]earch [N]eovim files" })
        -- vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
        -- vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
        -- vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })

        -- Others section
        vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffered files" })
        vim.keymap.set("n", "<leader>/", function()
            -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, { desc = "[/] Fuzzily search in current buffer" })

        vim.keymap.set("n", "<leader>t", function()
            vim.cmd("tab new")
            builtin.find_files({ no_ignore = true })
        end, { desc = "Search files in New [T]ab" })

        require("telescope").setup(settings)
    end,
}
