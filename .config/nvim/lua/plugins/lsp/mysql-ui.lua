return {
    {
        "kristijanhusak/vim-dadbod-completion",
        -- ft = { "sql", "mysql", "plsql" },
        dependencies = {
            { "tpope/vim-dadbod", lazy = true },
        },
        config = function()
            vim.api.nvim_create_user_command("DBConnect", function(arg)
                local name = arg.fargs[1] or ""
                if name == "" then
                    print("Current connection: " .. (vim.g.db or "none"))
                    print(":DB_Connect help for more information")
                    return
                elseif name == "help" then
                    print("Usage: DB_Connect <database_name/url>")
                    print("Example: DB_Connect mysql://user:password@localhost:3306/dbname")
                    return
                end

                vim.g.db = name
            end, { desc = "Connect to a database", nargs = 1 })

            vim.api.nvim_create_user_command("DBDisconnect", function()
                vim.g.db = ""
            end, { desc = "Disconnect from a database" })
        end,
    },
    { -- This reqiores to use vim-dadbod-ui, may be used later, if such configuration is needed
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod", lazy = true },
            "kristijanhusak/vim-dadbod-completion",
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },
}
