-- Lazily load copilot and avante when the user runs :CopilotSetup
-- NOTE: This is a workaround to avoid loading copilot and avante on startup, as this sw uses a lot of resources.

local opts_anante = {
    provider = "copilot",
    selection = {
        hint_display = "none",
    },
    behaviour = {
        auto_approve_tool_permissions = false,
        auto_set_keymaps = false,
    },
    windows = {
        width = 50,
        edit = { start_insert = false },
    },
}
local opts_copilot_cmp = {}

vim.api.nvim_create_user_command("CopilotSetup", function()
    require("avante").setup(opts_anante)
    require("copilot_cmp").setup(opts_copilot_cmp)
    -- TODO: find a better way to trigger copilot.vim setup
    vim.print("NOTE: (fix pending) Open a new file or run `:e` to activate Copilot inline suggestions")
end, { desc = "Setup Copilot and Avante" })

return {
    {
        "zbirenbaum/copilot-cmp",
        dependencies = {
            -- "zbirenbaum/copilot.lua", -- more efficient alternative written in lua
            "github/copilot.vim",
        },
        lazy = true,
        config = function() end,
    },
    {
        "yetone/avante.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        },
        build = vim.fn.has("win32") ~= 0
                and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            or "make",
        lazy = true,
        cmd = {},
        keys = {},
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>aa", "<cmd>AvanteAsk<CR>", { desc = "Ask Avante" })
            vim.api.nvim_set_keymap("n", "<leader>ac", "<cmd>AvanteChat<CR>", { desc = "Chat with Avante" })
            vim.api.nvim_set_keymap("n", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "Edit Avante" })
            vim.api.nvim_set_keymap("n", "<leader>af", "<cmd>AvanteFocus<CR>", { desc = "Focus Avante" })
            vim.api.nvim_set_keymap("n", "<leader>ah", "<cmd>AvanteHistory<CR>", { desc = "Avante History" })
            vim.api.nvim_set_keymap("n", "<leader>am", "<cmd>AvanteModels<CR>", { desc = "Select Avante Model" })
            vim.api.nvim_set_keymap("n", "<leader>an", "<cmd>AvanteChatNew<CR>", { desc = "New Avante Chat" })
            vim.api.nvim_set_keymap(
                "n",
                "<leader>ap",
                "<cmd>AvanteSwitchProvider<CR>",
                { desc = "Switch Avante Provider" }
            )
            vim.api.nvim_set_keymap("n", "<leader>ar", "<cmd>AvanteRefresh<CR>", { desc = "Refresh Avante" })
            vim.api.nvim_set_keymap("n", "<leader>as", "<cmd>AvanteStop<CR>", { desc = "Stop Avante" })
            vim.api.nvim_set_keymap("n", "<leader>at", "<cmd>AvanteToggle<CR>", { desc = "Toggle Avante" })
        end,
    },
}
