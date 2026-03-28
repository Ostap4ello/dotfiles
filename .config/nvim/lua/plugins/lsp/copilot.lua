-- Lazily load copilot and avante when the user runs :CopilotSetup
-- NOTE: This is a workaround to avoid loading copilot and avante on startup, as this sw uses a lot of resources.

-- https://github.com/yetone/avante.nvim/blob/main/lua/avante/config.lua
local opts_anante = {
    provider = "copilot",
    providers = {
        copilot = {
            model = "gpt-5.3-codex",
        },
    },
    behaviour = {
        auto_add_current_file = false,
        auto_approve_tool_permissions = false,
        use_cwd_as_project_root = true,
    },
    windows = {
        width = 50,
        edit = { start_insert = false },
    },
    selector = {
        provider = "telescope",
    },
    file_selector = {
        provider = "telescope",
    },
    disabled_tools = { "ls" },
}
local opts_copilot_cmp = {}

vim.api.nvim_create_user_command("CopilotSetup", function()
    require("copilot_cmp").setup(opts_copilot_cmp)
    -- TODO: find a better way to trigger copilot.vim setup
    vim.print("NOTE: (fix pending) Open a new file or run `:e` to activate Copilot inline suggestions")

    require("avante").setup(opts_anante)
    vim.api.nvim_create_user_command("AvanteZen", function()
        vim.cmd("tabnew")
        require("avante.api").zen_mode()
        vim.cmd("file AvanteZen")
        -- TODO: find a better way to close that empty buffer
        -- vim.cmd("wincmd h") -- move to the left window (avante)
        -- vim.cmd("wincmd q") -- close the right window (empty buffer)
    end, { desc = "Enable Avante Zen mode" })
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
            vim.api.nvim_set_keymap( "n", "<leader>ap", "<cmd>AvanteSwitchProvider<CR>", { desc = "Switch Avante Provider" })
            vim.api.nvim_set_keymap("n", "<leader>ar", "<cmd>AvanteRefresh<CR>", { desc = "Refresh Avante" })
            vim.api.nvim_set_keymap("n", "<leader>as", "<cmd>AvanteStop<CR>", { desc = "Stop Avante" })
            vim.api.nvim_set_keymap("n", "<leader>at", "<cmd>AvanteToggle<CR>", { desc = "Toggle Avante" })
            vim.api.nvim_set_keymap( "n", "<leader>az", "<cmd>AvanteZen<CR>", { desc = "Open Avante Zen mode" })
        end,
    },
}
