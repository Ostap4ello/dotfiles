-- Lazily load copilot and avante when the user runs :CopilotSetup
-- NOTE: This is a workaround to avoid loading copilot and avante on startup, as this sw uses a lot of resources.

-- https://github.com/yetone/avante.nvim/blob/main/lua/avante/config.lua
local opts_anante = {
    provider = "copilot",
    providers = {
        copilot = {
            -- model = "gpt-5.3-codex",
        },
    },
    behaviour = {
        auto_add_current_file = false,
        auto_approve_tool_permissions = false,
        use_cwd_as_project_root = true,
    },
    windows = {
        width = 50,
        edit = { start_insert = false },
    },
    selector = {
        provider = "telescope",
    },
    file_selector = {
        provider = "telescope",
    },
    disabled_tools = { "ls" },
}
local opts_copilot_cmp = {}

local function load_copilot()
    require("copilot_cmp").setup(opts_copilot_cmp)
    vim.print("NOTE: (fix pending) Open a new file or run `:e` to activate Copilot inline suggestions")
end

local function load_avante()
    require("avante").setup(opts_anante)
    vim.api.nvim_create_user_command("AvanteZen", function()
        vim.cmd("tabnew")
        require("avante.api").zen_mode()
        vim.cmd("file AvanteZen")
    end, { desc = "Enable Avante Zen mode" })
end

local function load_copilot_chat()
    if vim.fn.executable('copilot') == 1 then
        vim.api.nvim_create_user_command("CopilotChat", function()
            vim.cmd("tabnew | tabmove $ | file CopilotChat | terminal copilot ")
            -- Wait for first keypress (y/n) without Enter
            vim.cmd([[call feedkeys(nr2char(getchar()), 't')]])
        end, { desc = "Open Copilot in rightmost tab" })
        local confirm = vim.fn.input('Create CopilotChat command? (y/n): ')
        if confirm:lower() == 'y' then
            vim.cmd("CopilotChat")
        end
    end
end

local function load_opencode()
    require("opencode").start()
end

local ai_tools = { "copilot", "avante", "copilot_chat", "opencode" }

vim.api.nvim_create_user_command("AISetup", function(opts)
    local arg = opts.fargs[1]
    if arg == "copilot" then
        load_copilot()
    elseif arg == "avante" then
        load_avante()
    elseif arg == "copilot_chat" then
        load_copilot_chat()
    elseif arg == "opencode" then
        load_opencode()
    else
        load_copilot()
        load_avante()
        load_copilot_chat()
    end
end, {
    desc = "Setup AI tools. Usage: :AISetup [copilot|avante|copilot_chat|opencode]. No arg = all but opencode.",
    nargs = "?",
    complete = function(ArgLead, CmdLine, CursorPos)
        local matches = {}
        for _, v in ipairs(ai_tools) do
            if v:find(ArgLead, 1, true) == 1 then
                table.insert(matches, v)
            end
        end
        return matches
    end,
})

return {
    {
        "zbirenbaum/copilot-cmp",
        dependencies = {
            -- "zbirenbaum/copilot.lua", -- more efficient alternative written in lua
            "github/copilot.vim",
        },
        lazy = true,
        config = function() end,
    },
    {
        "yetone/avante.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        },
        build = vim.fn.has("win32") ~= 0
                and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            or "make",
        lazy = true,
        cmd = {},
        keys = {},
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>aa", "<cmd>AvanteAsk<CR>", { desc = "Ask Avante" })
            vim.api.nvim_set_keymap("n", "<leader>ac", "<cmd>AvanteChat<CR>", { desc = "Chat with Avante" })
            vim.api.nvim_set_keymap("n", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "Edit Avante" })
            vim.api.nvim_set_keymap("n", "<leader>af", "<cmd>AvanteFocus<CR>", { desc = "Focus Avante" })
            vim.api.nvim_set_keymap("n", "<leader>ah", "<cmd>AvanteHistory<CR>", { desc = "Avante History" })
            vim.api.nvim_set_keymap("n", "<leader>am", "<cmd>AvanteModels<CR>", { desc = "Select Avante Model" })
            vim.api.nvim_set_keymap("n", "<leader>an", "<cmd>AvanteChatNew<CR>", { desc = "New Avante Chat" })
            vim.api.nvim_set_keymap(
                "n",
                "<leader>ap",
                "<cmd>AvanteSwitchProvider<CR>",
                { desc = "Switch Avante Provider" }
            )
            vim.api.nvim_set_keymap("n", "<leader>ar", "<cmd>AvanteRefresh<CR>", { desc = "Refresh Avante" })
            vim.api.nvim_set_keymap("n", "<leader>as", "<cmd>AvanteStop<CR>", { desc = "Stop Avante" })
            vim.api.nvim_set_keymap("n", "<leader>at", "<cmd>AvanteToggle<CR>", { desc = "Toggle Avante" })
            vim.api.nvim_set_keymap("n", "<leader>az", "<cmd>AvanteZen<CR>", { desc = "Open Avante Zen mode" })
        end,
    },
    {
        "nickjvandyke/opencode.nvim",
        version = "*", -- Latest stable release
        lazy = true,
        dependencies = {
            {
                -- `snacks.nvim` integration is recommended, but optional
                ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
                "folke/snacks.nvim",
                optional = true,
                opts = {
                    input = {}, -- Enhances `ask()`
                    picker = { -- Enhances `select()`
                        actions = {
                            opencode_send = function(...)
                                return require("opencode").snacks_picker_send(...)
                            end,
                        },
                        win = {
                            input = {
                                keys = {
                                    ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                                },
                            },
                        },
                    },
                },
            },
        },
        config = function()
            local opencode_jobs = {}

            local function stop_opencode_job(job_id)
                if not job_id or job_id <= 0 then
                    return
                end

                local status = vim.fn.jobwait({ job_id }, 0)[1]
                if status == -1 then
                    vim.fn.jobstop(job_id)
                end
                opencode_jobs[job_id] = nil
            end

            local function stop_all_opencode_jobs()
                for job_id, _ in pairs(opencode_jobs) do
                    stop_opencode_job(job_id)
                end
            end

            local function is_opencode_job(job_id)
                if not job_id or job_id <= 0 then
                    return false
                end

                local pid = vim.fn.jobpid(job_id)
                if not pid or pid <= 0 then
                    return false
                end

                local ok, cmdline = pcall(vim.fn.readfile, "/proc/" .. pid .. "/cmdline", "b")
                if not ok or not cmdline or #cmdline == 0 then
                    return false
                end

                local raw = table.concat(cmdline, " "):gsub("%z", " ")
                return raw:find("opencode", 1, true) ~= nil
            end

            vim.api.nvim_create_autocmd("TermOpen", {
                pattern = "*",
                callback = function(args)
                    local ok, job_id = pcall(vim.api.nvim_buf_get_var, args.buf, "terminal_job_id")
                    if not ok or not is_opencode_job(job_id) then
                        return
                    end

                    opencode_jobs[job_id] = true
                    vim.api.nvim_buf_set_var(args.buf, "opencode_terminal_job_id", job_id)

                    -- Set local keymaps for opencode terminals
                    vim.api.nvim_buf_set_keymap(args.buf, "n", "<C-u>", function()
                        require("opencode").command("session.half.page.up")
                    end, { noremap = true, silent = true, desc = "Scroll opencode up" })
                    vim.api.nvim_buf_set_keymap(args.buf, "n", "<C-d>", function()
                        require("opencode").command("session.half.page.down")
                    end, { noremap = true, silent = true, desc = "Scroll opencode down" })

                    -- Move the terminal into a new tab if it is an opencode job
                    vim.cmd("wincmd T")
                end,
            })

            vim.api.nvim_create_autocmd("VimLeavePre", {
                callback = stop_all_opencode_jobs,
            })

            ---@type opencode.Opts
            vim.g.opencode_opts = {
                -- Your configuration, if any; goto definition on the type or field for details
            }

            vim.o.autoread = true -- Required for `opts.events.reload`

            -- vim.keymap.set({ "n", "x" }, "<C-x>", function()
            --     require("opencode").start()
            --     require("opencode").select()
            -- end, { desc = "Execute opencode action..." })

            vim.keymap.set({ "n", "x" }, "<leader>xa", function()
                require("opencode").ask("@this: ", { submit = true })
            end, { desc = "Ask opencode..." })

            vim.keymap.set({ "n", "x" }, "<leader>xr", function()
                return require("opencode").operator("@this ")
            end, { desc = "Add range to opencode", expr = true })
            vim.keymap.set("n", "<leader>xl", function()
                return require("opencode").operator("@this ") .. "_"
            end, { desc = "Add line to opencode", expr = true })

            -- vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
            -- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })

            vim.api.nvim_create_user_command("Opencode", function()
                require("opencode").start()
            end, { desc = "Show the single opencode terminal in a tab (reuse plugin managed instance)" })
        end,
    },
}
