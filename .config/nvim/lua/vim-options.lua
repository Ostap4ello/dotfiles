-- Global opts
vim.opt.clipboard = "unnamedplus"

vim.opt.mouse = "a"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Save undo history
vim.opt.undofile = true

-- TODO: wtf is that
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Keep signcolumn on by default (col with errs at left)
vim.opt.signcolumn = "yes"

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Set updatetime (cursorhold, hints, etc)
vim.opt.updatetime = 100

-- Show matching paterns as you type
vim.opt.inccommand = "split"

-- UI : Don't show the mode, since it's already in the status line
vim.opt.showmode = true
vim.opt.number = true
vim.opt.fillchars = { eob = " " }

-- Code formatting and tab
vim.opt.expandtab = true -- TODO: <-
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winpos,terminal,localoptions"
vim.opt.formatoptions = "tcroqlj" --<- TODO:

-- Wrap for different filetypes
vim.opt.wrap = false
vim.opt.linebreak = false

-- Vim window width
vim.g.winminwidth = 6
vim.g.winminheight = 6

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.gay",
    command = "set filetype=gay",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "txt", "markdown", "rst", "gay" },
    command = "setlocal linebreak wrap",
})

-- Set the commentstring for C and C++ files
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    command = "setlocal commentstring=//\\ %s",
})

-- Make nvim-tree follow the root of the vim (:cd commands)
-- vim.api.nvim_create_autocmd("DirChanged", {
--   pattern = "*",
--   callback = function()
--     -- Check if nvim-tree is loaded
--     local nvim_tree = require("nvim-tree.api")
--     if nvim_tree then
--       -- Change nvim-tree's root directory to match Neovim's CWD
--       nvim_tree.tree.change_root(vim.fn.getcwd())
--     end
--   end,
-- })

-- vim.o.cmdheight = 0
vim.o.termguicolors = false
