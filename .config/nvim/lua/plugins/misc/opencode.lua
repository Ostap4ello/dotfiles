return {
    "nickjvandyke/opencode.nvim",
    version = "*", -- Latest stable release
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
                vim.api.nvim_buf_set_keymap(
                    args.buf,
                    "n",
                    "<C-u>",
                    function ()
                        require('opencode').command('session.half.page.up')
                    end,
                    { noremap = true, silent = true, desc = "Scroll opencode up" }
                )
                vim.api.nvim_buf_set_keymap(
                    args.buf,
                    "n",
                    "<C-d>",
                    function ()
                        require('opencode').command('session.half.page.down')
                    end,
                    { noremap = true, silent = true, desc = "Scroll opencode down" }
                )

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

        vim.keymap.set({ "n", "x" }, "<C-x>", function()
            require("opencode").start()
            require("opencode").select()
        end, { desc = "Execute opencode action..." })

        vim.keymap.set({ "n", "x" }, "<leader>oa", function()
            require("opencode").ask("@this: ", { submit = true })
        end, { desc = "Ask opencode..." })

        vim.keymap.set({ "n", "x" }, "<leader>or", function()
            return require("opencode").operator("@this ")
        end, { desc = "Add range to opencode", expr = true })
        vim.keymap.set("n", "<leader>ol", function()
            return require("opencode").operator("@this ") .. "_"
        end, { desc = "Add line to opencode", expr = true })

        vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
        vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })

        vim.api.nvim_create_user_command("Opencode", function()
            require("opencode").start()
        end, { desc = "Show the single opencode terminal in a tab (reuse plugin managed instance)" })
    end,
}
