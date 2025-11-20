return {
    "rmagatti/auto-session",
    config = function()
        require("auto-session").setup({
            auto_session_suppress_dirs = { "~/", "/" }, -- Directories to suppress auto-session
        })

        vim.keymap.set("n", "<leader>ss", function()
            vim.cmd("SessionSearch")
        end, { desc = "[S]earch Saved [S]essions" })
    end,
}
