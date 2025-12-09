-- lazy plugins section
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- nvim native settings
require("vim-options")
require("vim-binds-native")

if vim.g.vscode then
    -- VSCode extension

    -- import configs
    -- require("lazy").setup({
    -- 	spec = {
    -- 		-- { import = "plugins" },
    -- 		-- { import = "plugins/utils" },
    -- 		-- { import = "plugins/lsp" },
    -- 		-- { import = "plugins/misc" },
    -- 	},
    -- })
elseif vim.g.neovide then
    -- Neovide GUI

    require("neovide-conf")
    -- require("nvim-tree.api").tree.close()
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.cmd("SessionSearch")
        end,
    })
else
    -- ordinary Neovim

    -- import configs
    require("lazy").setup({
        spec = {
            { import = "plugins" },
            { import = "plugins/utils" },
            { import = "plugins/lsp" },
            { import = "plugins/misc" },
        },
    })

    -- commands to run as nvim starts
    -- vim.cmd("colorscheme default")
    vim.cmd("colorscheme default")
end
vim.cmd("Copilot disable")
