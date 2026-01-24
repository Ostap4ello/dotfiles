return {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
        -- Will use Telescope if installed or a vim.ui.select picker otherwise
        { "<leader>ww", "<cmd>AutoSession search<CR>", desc = "Session search" },
        { "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
        { "<leader>wa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
    },
    opts = {
        suppress_dirs = { "~/", "/" }, -- Directories to suppress auto-session
        auto_create = false,
    },
}
