-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
--
-- PlatformIO integration for ESP32 development
-- Provides build/upload/monitor commands and clangd compile_commands.json setup.
--
-- Keymaps (under <leader>p):
--   <leader>pb  Build
--   <leader>pu  Upload firmware
--   <leader>pm  Serial monitor
--   <leader>pc  Clean
--   <leader>pU  Upload + monitor
--   <leader>pC  Generate compile_commands.json (and link to project root for clangd)
--   <leader>pd  Debug (interactive GDB via pio debug — ESP32 GDB is too old for DAP)
return {
    dir = vim.fn.stdpath("config"),
    name = "platformio",
    config = function()
        -- Run a pio command in a bottom terminal split
        local function pio_term(args)
            -- Create a fresh buffer so termopen never targets the main buffer
            local buf = vim.api.nvim_create_buf(false, true)
            vim.cmd("botright 15split")
            local win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(win, buf)
            vim.fn.termopen("pio " .. args, {
                on_exit = function(_, code, _)
                    local level = code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
                    vim.notify(("[PlatformIO] `pio %s` exited with code %d"):format(args, code), level)
                end,
            })
            vim.cmd("startinsert")
        end

        -- Build
        vim.api.nvim_create_user_command("PioBuild", function()
            pio_term("run")
        end, { desc = "PlatformIO: Build project" })

        -- Upload
        vim.api.nvim_create_user_command("PioUpload", function()
            pio_term("run --target upload")
        end, { desc = "PlatformIO: Upload firmware" })

        -- Run a pio command in a terminal, killing the entire process group when
        -- the window is closed so child processes (miniterm, etc.) release the serial port.
        local function pio_term_monitor(args)
            local buf = vim.api.nvim_create_buf(false, true)
            vim.cmd("botright 15split")
            local win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(win, buf)
            -- wipe the buffer when the window closes so BufWipeout fires
            vim.bo[buf].bufhidden = "wipe"
            local job_id = vim.fn.termopen("pio " .. args, {
                on_exit = function(_, code, _)
                    local level = code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
                    vim.notify(("[PlatformIO] `pio %s` exited with code %d"):format(args, code), level)
                end,
            })
            -- BufWipeout fires when the buffer is wiped (triggered by bufhidden=wipe on :q)
            vim.api.nvim_create_autocmd("BufWipeout", {
                buffer = buf,
                once = true,
                callback = function()
                    -- Kill the whole process group so miniterm/pyserial children release the port.
                    -- Use pcall in case the job already exited (invalid channel id).
                    local ok, pid = pcall(vim.fn.jobpid, job_id)
                    if ok and pid and pid > 0 then
                        vim.fn.system({ "kill", "-TERM", "-" .. pid })
                    end
                    pcall(vim.fn.jobstop, job_id)
                end,
            })
            -- Esc exits terminal mode so you can navigate windows; press i to re-enter
            vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = buf, desc = "Exit terminal mode" })
            vim.cmd("startinsert")
        end

        -- Serial monitor
        vim.api.nvim_create_user_command("PioMonitor", function()
            pio_term_monitor("device monitor")
        end, { desc = "PlatformIO: Serial monitor" })

        -- Clean
        vim.api.nvim_create_user_command("PioClean", function()
            pio_term("run --target clean")
        end, { desc = "PlatformIO: Clean build artifacts" })

        -- Upload then monitor
        vim.api.nvim_create_user_command("PioUploadMonitor", function()
            pio_term_monitor("run --target upload --target monitor")
        end, { desc = "PlatformIO: Upload and open serial monitor" })

        -- Generate compile_commands.json and link to project root for clangd
        vim.api.nvim_create_user_command("PioCompileDB", function()
            local cwd = vim.fn.getcwd()
            vim.cmd("botright 10split")
            vim.fn.termopen("pio run --target compiledb", {
                on_exit = function(_, code, _)
                    if code ~= 0 then
                        vim.notify("[PlatformIO] compiledb failed", vim.log.levels.ERROR)
                        return
                    end
                    -- PlatformIO writes compile_commands.json to .pio/build/<env>/
                    -- Link the first one found to the project root so clangd picks it up.
                    local files = vim.fn.glob(cwd .. "/.pio/build/*/compile_commands.json", false, true)
                    if #files == 0 then
                        vim.notify("[PlatformIO] No compile_commands.json generated", vim.log.levels.WARN)
                        return
                    end
                    local src = files[1]
                    if #files > 1 then
                        vim.notify(("[PlatformIO] Multiple envs — linking %s"):format(src), vim.log.levels.WARN)
                    end
                    vim.fn.system({ "ln", "-sf", src, cwd .. "/compile_commands.json" })
                    vim.notify("[PlatformIO] compile_commands.json linked; restarting clangd", vim.log.levels.INFO)
                    vim.cmd("LspRestart clangd")
                end,
            })
            vim.cmd("startinsert")
        end, { desc = "PlatformIO: Generate compile_commands.json for clangd" })

        -- Interactive GDB debug session via PlatformIO.
        -- Note: Espressif's bundled xtensa-esp32-elf-gdb is v12 and does NOT support
        -- --interpreter=dap, so nvim-dap cannot drive it. Use this for a raw GDB terminal.
        -- For JTAG: ensure your debug adapter is connected before running.
        vim.api.nvim_create_user_command("PioDebug", function()
            pio_term("debug --interface gdb -x .pioinit")
        end, { desc = "PlatformIO: Interactive GDB debug session (terminal)" })

        -- Keymaps
        local ok, wk = pcall(require, "which-key")
        if ok then
            wk.add({ { "<leader>p", group = "[P]latformIO" } })
        end

        vim.keymap.set("n", "<leader>pb", "<cmd>PioBuild<CR>", { desc = "PlatformIO: [B]uild" })
        vim.keymap.set("n", "<leader>pu", "<cmd>PioUpload<CR>", { desc = "PlatformIO: [U]pload" })
        vim.keymap.set("n", "<leader>pm", "<cmd>PioMonitor<CR>", { desc = "PlatformIO: [M]onitor" })
        vim.keymap.set("n", "<leader>pc", "<cmd>PioClean<CR>", { desc = "PlatformIO: [C]lean" })
        vim.keymap.set("n", "<leader>pU", "<cmd>PioUploadMonitor<CR>", { desc = "PlatformIO: [U]pload+Monitor" })
        vim.keymap.set("n", "<leader>pC", "<cmd>PioCompileDB<CR>", { desc = "PlatformIO: compile_[C]ommands.json" })
        vim.keymap.set("n", "<leader>pd", "<cmd>PioDebug<CR>", { desc = "PlatformIO: [D]ebug (GDB terminal)" })
    end,
}
