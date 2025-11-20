return {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    opts = {},
    event = "VeryLazy",
    config = function()
        require("venv-selector").setup({
            stay_on_this_version = true,
            name = { "venv", ".venv", "" },
        })
    end,
}
