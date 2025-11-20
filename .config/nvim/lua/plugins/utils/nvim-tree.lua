return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            -- "nvim-lua/plenary.nvim",
            -- "nvim-tree/nvim-web-devicons",
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

            vim.keymap.set("n", "<leader>w", function()
                -- vim.cmd("wincmd =")
                local picked_window_id = require("window-picker").pick_window({
                    include_current_win = true,
                }) or vim.api.nvim_get_current_win()
                vim.api.nvim_set_current_win(picked_window_id)
            end, { desc = "Pick a window" })
        end,
    },
    -- {
    -- 	"nvim-tree/nvim-tree.lua",
    -- 	version = "*",
    -- 	lazy = false,
    -- 	dependencies = {
    -- 		"nvim-tree/nvim-web-devicons",
    -- 	},
    -- 	config = function()
    -- 		local function my_on_attach(bufnr)
    -- 			local api = require("nvim-tree.api")
    --
    -- 			local function opts(desc)
    -- 				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    -- 			end
    --
    -- 			-- default mappings
    -- 			api.config.mappings.default_on_attach(bufnr)
    --
    -- 			-- custom mappings
    -- 			--vim.keymap.set('n', '<left>',	api.tree.change_root_to_parent, opts('Up'))
    -- 			--vim.keymap.set('n', '<right>',  api.tree.change_root_to_node, opts('CD'))
    -- 			--vim.keymap.set('n', '<left>',	api.tree.change_root_to_parent, opts('Up'))
    -- 			vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
    --
    -- 			-- Override color groups
    -- 			vim.cmd(":hi NvimTreeGitNew guifg=#88c0d0")
    -- 			vim.cmd(":hi NvimTreeGitDeleted guifg=#88c0d0")
    -- 			vim.cmd(":hi NvimTreeGitDirty guifg=#88c0d0")
    -- 			vim.cmd(":hi NvimTreeGitStaged guifg=#88c0d0")
    -- 		end
    --
    -- 		require("nvim-tree").setup({
    -- 			diagnostics = {
    -- 				enable = true,
    -- 				show_on_dirs = true,
    -- 				show_on_open_dirs = true,
    -- 			},
    -- 			hijack_cursor = true,
    -- 			sort = {
    -- 				sorter = "case_sensitive",
    -- 			},
    -- 			view = {
    -- 				width = 30,
    -- 			},
    -- 			filters = {
    -- 				dotfiles = false,
    -- 				git_ignored = false,
    -- 			},
    -- 			on_attach = my_on_attach,
    -- 			auto_reload_on_write = true,
    -- 			modified = {
    -- 				enable = true,
    -- 			},
    -- 			renderer = {
    -- 				group_empty = true,
    -- 				highlight_opened_files = "name", -- "none" (default), "icon", "name" or "all"
    -- 				highlight_modified = "all",
    -- 				highlight_git = "none",
    -- 				indent_markers = {
    -- 					enable = true,
    -- 					inline_arrows = true,
    -- 					icons = {
    -- 						corner = "└",
    -- 						edge = "│",
    -- 						item = "│",
    -- 						bottom = "─",
    -- 						none = " ",
    -- 					},
    -- 				},
    -- 				icons = {
    -- 					git_placement = "after",
    -- 					modified_placement = "before",
    -- 					diagnostics_placement = "signcolumn",
    -- 					bookmarks_placement = "signcolumn",
    -- 				},
    -- 			},
    -- 		})
    -- 		-- Open NvimTreevim
    -- 		vim.keymap.set("n", "<leader>b", ":NvimTreeToggle<CR>", {desc="Toggle Nvim Tree"})
    -- 		if vim.fn.argc() == 0 then
    --          require("nvim-tree.api").tree.open()
    --      end
    --
    -- 	end,
    -- },
}
