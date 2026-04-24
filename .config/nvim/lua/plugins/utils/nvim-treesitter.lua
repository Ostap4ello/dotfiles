return {
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({})
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            -- "HiPhish/nvim-ts-rainbow2",
        },
        config = function()
            local config = require("nvim-treesitter.config")
            config.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "bash", "python", "java" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
                modules = {},
                auto_install = false,
                ignore_install = {},
            })
        end,
    },
    {
        "aklt/plantuml-syntax",
        commit = "9d4900aa16674bf5bb8296a72b975317d573b547",
    },
}
