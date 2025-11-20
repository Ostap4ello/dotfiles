return {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "[C]ode [F]ormat buffer",
        },
    },
    opts = {
        notify_on_error = false,
        -- format_on_save = function(bufnr)
        -- 	-- Disable "format_on_save lsp_fallback" for languages that don't
        -- 	-- have a well standardized coding style. You can add additional
        -- 	-- languages here or re-enable it for the disabled ones.
        -- 	local disable_filetypes = { c = true, cpp = true }
        -- 	return {
        -- 		timeout_ms = 500,
        -- 		lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        -- 	}
        -- end,
        formatters_by_ft = {
            lua = { "stylua_custom" },
            python = { "black" },
            sh = { "beautysh" },
            -- zsh = { "beautysh" },
            -- csh = { "beautysh" },
            -- ksh = { "beautysh" },
            bash = { "beautysh" },
            assembly = { "asmfmt" },
            c = { "clang-format_custom" },
            cpp = { "clang-format_custom" },
        },
        formatters = {
            stylua_custom = {
                command = "stylua",
                args = { "--indent-type", "Spaces", "--indent-width", "4", "-" },
                stdin = true,
            },
            ["clang-format_custom"] = {
                command = "clang-format",
                args = {
                    "-style={BasedOnStyle: GNU, IndentWidth: 4, TabWidth: 4, ColumnLimit: 100}",
                },
                stdin = true,
            },
        },
    },
}
