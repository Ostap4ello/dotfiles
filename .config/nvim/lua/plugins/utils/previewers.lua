return {
    --
    -- Previewer aucmd template:
    -- (Reolace <previewer>, <previewer_extension>, and <previewer_command> with corresponding values)
    --
    -- local id = nil
    -- local startPreview = function()
    -- 	id = vim.api.nvim_create_autocmd("BufWritePost", {
    -- 		buffer = 0,
    -- 		callback = function()
    --          <previewer_command>
    -- 		end,
    -- 	})
    -- end
    --
    -- local stopPreview = function()
    -- 	if id ~= nil then
    -- 		vim.api.nvim_del_autocmd(id)
    -- 	end
    -- end
    --
    -- vim.api.nvim_create_autocmd("BufEnter", {
    -- 	pattern = "*.<previewer_extension>",
    -- 	callback = function()
    -- 		vim.api.nvim_buf_create_user_command(0, "<previewer>StartPreview", startPreview, {})
    -- 		vim.api.nvim_buf_create_user_command(0, "<previewer>StopPreview", stopPreview, {})
    -- 	end,
    -- 	group = vim.api.nvim_create_augroup("<previewer>PreviewerGroup", {}),
    -- 	desc = "Set command for <previewer>",
    -- })
    {
        "Maduki-tech/nvim-plantuml",
        config = function()
            require("plantuml").setup({})

            local id = nil
            local startPreview = function()
                id = vim.api.nvim_create_autocmd("BufWritePost", {
                    buffer = 0,
                    callback = function()
                        vim.cmd("PlantUML export")
                    end,
                })
            end

            local stopPreview = function()
                if id ~= nil then
                    vim.api.nvim_del_autocmd(id)
                end
            end

            -- local insertEssentials = function()
            -- 	local headers = {
            -- 		"---",
            -- 		"pandoc_:",
            -- 		" - output: .pdf",
            -- 		" - template: codedoc.tex",
            -- 		" - pdf-engine: xelatex",
            -- 		"output:",
            -- 		"  pdf_document:",
            -- 		"    latex_engine: xelatex",
            -- 		"    fig_caption: true",
            -- 		"---",
            -- 	}
            -- 	vim.api.nvim_buf_set_lines(0, 0, 1, false, headers)
            -- end

            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "*.puml",
                callback = function()
                    vim.api.nvim_buf_create_user_command(0, "PUMLStartPreview", startPreview, {})
                    vim.api.nvim_buf_create_user_command(0, "PUMLStopPreview", stopPreview, {})
                    -- vim.api.nvim_buf_create_user_command(0, "PUMLInsertHeaders", insertEssentials, {})
                end,
                group = vim.api.nvim_create_augroup("PUMLPreviewerGroup", {}),
                desc = "Set command for PlantUML",
            })

            -- vim.api.nvim_create_autocmd("BufEnter", {
            -- 	pattern = "*.puml",
            -- 	callback = function()
            -- 		vim.keymap.set("n", "<leader>p", "<cmd>PlantUML export<CR>", { desc = "Open PlantUML Preview" })
            -- 	end,
            -- })
        end,
        auto_refresh = true,
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownStartPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "jghauser/auto-pandoc.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        ft = "markdown",

        config = function()
            local id = nil
            local startPandocPreview = function()
                id = vim.api.nvim_create_autocmd("BufWritePost", {
                    buffer = 0,
                    callback = function()
                        require("auto-pandoc").run_pandoc()
                    end,
                })
            end

            local stopPandocPreview = function()
                if id ~= nil then
                    vim.api.nvim_del_autocmd(id)
                end
            end

            local insertHeaders = function()
                local headers = {
                    "---",
                    "pandoc_:",
                    " - output: .pdf",
                    " - template: codedoc.tex",
                    " - pdf-engine: xelatex",
                    "output:",
                    "  pdf_document:",
                    "    latex_engine: xelatex",
                    "    fig_caption: true",
                    "---",
                }
                vim.api.nvim_buf_set_lines(0, 0, 1, false, headers)
            end

            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "*.md",
                callback = function()
                    vim.api.nvim_buf_create_user_command(0, "PandocStartPreview", startPandocPreview, {})
                    vim.api.nvim_buf_create_user_command(0, "PandocStopPreview", stopPandocPreview, {})
                    vim.api.nvim_buf_create_user_command(0, "PandocInsertHeaders", insertHeaders, {})
                end,
                group = vim.api.nvim_create_augroup("PandocPreviewerGroup", {}),
                desc = "Set keymap for auto-pandoc",
            })
        end,
    },
}
