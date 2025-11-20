-- Binds-and-commands

-- Open terminal in a new tab
vim.keymap.set("n", "<leader>T", function()
    vim.cmd("tab new")
    vim.cmd("terminal")
end, { desc = "Open Terminal In New Tab" })
-- Escape terminal mode bind
-- vim.keymap.set("t", "<esc>", "<c-\\><c-n><CR>", {noremap=true, silent=true})
-- Save and quit ALL
vim.cmd("command! WQ wa | qa")

vim.api.nvim_create_user_command("BTerm", function()
    vim.cmd("vertical terminal")
    vim.cmd("wincmd J")
    vim.cmd("wincmd 99 -")
    vim.cmd("wincmd 7 +")
end, {})

vim.api.nvim_create_user_command("BTermDouble", function()
    vim.cmd("vertical terminal")
    vim.cmd("wincmd J")
    vim.cmd("wincmd 99 -")
    vim.cmd("wincmd 7 +")
    vim.cmd("vertical terminal")
end, {})

vim.api.nvim_create_user_command("TermNewTab", function()
    vim.cmd("tabnew")
    vim.cmd("terminal")
end, {})

vim.api.nvim_create_user_command("Zathura", function()
    vim.cmd("! zathura . &")
end, {})
-- vim.api.nvim_create_user_command("Tab", function()
-- 	vim.cmd("vertical new")
-- end, {})


vim.api.nvim_create_user_command("QuoteFile", function()
    -- Get the start and end positions of the visual selection
    local start_pos = vim.fn.getpos("'<")[2]
    local end_pos = vim.fn.getpos("'>")[2]

    local lines = table.concat(vim.fn.getline(start_pos, end_pos), "\n")
    local filename = vim.fn.expand("%:.")

    -- exceptions
    if string.find(filename, ".h$") then
        string.gsub(filename, ".h$", ".cpp")
    end

    --
    local quote
    if start_pos == end_pos then
        quote = string.format(
            [[
```%s at %s
%s
```
          ]],
            filename,
            start_pos,
            lines
        )
    else
        quote = string.format(
            [[
```%s at %s~%s
%s
```
          ]],
            filename,
            start_pos,
            end_pos,
            lines
        )
    end

    vim.fn.setreg("+", quote, "V")
    vim.fn.setreg('"', quote, "V")
end, { range = true, desc = "Creates .md styled selected area reference of selected code" })

--vim.keymap.set('i', '<C-Tab>', '<Plug>(copilot-accept-word)')
vim.keymap.set("t", "<c-w>", "<c-\\><c-n><c-w>")

-- NOTE: alt will be used as the leader key for enviroment console,
-- so it shall look like this:
-- gui - meta
-- terminal - alt
-- vim - leader (space)

-- Alt + T to open terminal in a new tab
-- vim.keymap.set({ "n", "v" }, "<leader>T", ":tabnew<CR>:terminal<CR>")
-- Alt + t to move to the next tab
-- vim.keymap.set({ "n", "v" }, "<A-t>", "<c-w>T")
-- vim.keymap.set("t", "<A-t>", "<c-\\><c-n><c-w>T")
-- Leader -> Arrows to move focus between windows in normal, terminal and visual mode
vim.keymap.set({ "n", "v" }, "<leader><down>", "<c-w><down>")
vim.keymap.set({ "n", "v" }, "<leader><left>", "<c-w><left>")
vim.keymap.set({ "n", "v" }, "<leader><right>", "<c-w><right>")
vim.keymap.set({ "n", "v" }, "<leader><up>", "<c-w><up>")

-- vim.keymap.set("t", "<leader><down>", "<c-\\><c-n><c-w><down>")
-- vim.keymap.set("t", "<leader><left>", "<c-\\><c-n><c-w><left>")
-- vim.keymap.set("t", "<leader><right>", "<c-\\><c-n><c-w><right>")
-- vim.keymap.set("t", "<leader><up>", "<c-\\><c-n><c-w><up>")

-- Alt + Ctrl + Arrows to resize windows in normal, terminal and visual mode
vim.keymap.set({ "n", "v" }, "<leader><C-down>", ":resize -10<CR>")
vim.keymap.set({ "n", "v" }, "<leader><C-left>", ":vertical resize -16<CR>")
vim.keymap.set({ "n", "v" }, "<leader><C-right>", ":vertical resize +16<CR>")
vim.keymap.set({ "n", "v" }, "<leader><C-up>", ":resize +10<CR>")

-- vim.keymap.set("t", "<leader><C-down>", "<c-\\><c-n> :resize -10<CR>")
-- vim.keymap.set("t", "<leader><C-left>", "<c-\\><c-n><c-w><left> :vertical resize -16<CR>")
-- vim.keymap.set("t", "<leader><C-right>", "<c-\\><c-n><c-w><right> :vertical resize +16<CR>")
-- vim.keymap.set("t", "<leader><C-up>", "<c-\\><c-n><c-w><up> :resize +10<CR>")
