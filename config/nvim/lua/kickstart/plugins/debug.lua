-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'mfussenegger/nvim-dap-python',
    'julianolf/nvim-dap-lldb',
    'nvim-neotest/nvim-nio',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },

  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    require('dap-python').setup(vim.env.HOME .. '/.virtualenvs/debugpy/bin/python')
    -- define path based off of environment variable VSCODE_LLDB_PATH, if it exists otherwise use a sensible default
    local lldb_path = os.getenv 'VSCODE_LLDB_PATH' or '/usr/bin/codelldb'

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<leader>n', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<leader>co', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<leader>cO', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>ci', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<leader>cs', dap.terminate, { desc = 'Debug: Terminate' })
    vim.keymap.set('n', '<leader>cr', dap.restart, { desc = 'Debug: Restart' })
    vim.keymap.set('n', '<leader>cc', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<leader>cp', dap.pause, { desc = 'Debug: Pause' })

    vim.keymap.set('n', '<leader>cb', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>cB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    dap.adapters.delve = {
      type = 'server',
      host = '127.0.0.1',
      port = '8086',
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:8086', '--log', '--log-output=dap' },
      },
    }

    dap.configurations.go = {
      {
        type = 'delve',
        name = 'Debug Go',
        request = 'launch',
        program = '${file}',
        outputMode = 'remote',
      },
    }

    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = lldb_path, -- or if not in $PATH: "/absolute/path/to/codelldb"
        args = { '--port', '${port}' },
      },
    }

    -- GDB DAP adapter (requires GDB 14+, available on NixOS unstable).
    -- Used for attaching to OpenOCD's GDB server for ESP32 JTAG debugging.
    dap.adapters.gdb = {
      type = 'executable',
      command = 'gdb',
      args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
      options = { disconnect_timeout_sec = 5 },
    }

    dap.configurations.cpp = {
      -- CMake native builds
      {
        name = 'CMake: Launch',
        type = 'codelldb',
        request = 'launch',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        program = function()
          local out = vim.fn.system { 'cmake', '--build', 'build' }
          if vim.v.shell_error ~= 0 then
            vim.notify(out, vim.log.levels.ERROR)
            return nil
          end
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/src/', 'file')
        end,
        terminal = 'console',
      },
      -- PlatformIO ESP32: attach to OpenOCD GDB server on port 3333.
      -- Prerequisites:
      --   1. Build with <leader>pb
      --   2. Start OpenOCD: run `<leader>pd` (pio debug --interface gdb -x .pioinit)
      --      then in a second terminal: connect gdb to :3333 once OpenOCD is ready.
      --   OR for automated JTAG: start OpenOCD manually, then use this config.
      -- Note: requires GDB 14+ (host gdb with --interpreter=dap).
      -- Espressif's xtensa-esp32-elf-gdb is v12 and cannot drive this;
      -- this config uses the system gdb (multiarch) connecting to OpenOCD.
      {
        name = 'PlatformIO ESP32 (OpenOCD JTAG on :3333)',
        type = 'gdb',
        request = 'attach',
        target = 'extended-remote :3333',
        program = function()
          local cwd = vim.fn.getcwd()
          local files = vim.fn.glob(cwd .. '/.pio/build/*/firmware.elf', false, true)
          if #files == 1 then
            return files[1]
          elseif #files > 1 then
            local items = vim.tbl_map(function(f)
              return vim.fn.fnamemodify(f, ':~:.')
            end, files)
            local choice = vim.fn.inputlist(vim.list_extend({ 'Select firmware.elf:' }, items))
            if choice > 0 then
              return files[choice]
            end
          end
          return vim.fn.input('Path to firmware.elf: ', cwd .. '/.pio/build/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
      },
    }
    dap.adapters.python = {
      type = 'executable',
      command = vim.env.HOME .. '/.virtualenvs/debugpy/bin/python',
      args = { '-m', 'debugpy.adapter' },
    }

    dap.configurations.python = {
      {
        -- The first three options are required by nvim-dap
        type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = 'launch',
        name = 'Launch file',
        cwd = '${workspaceFolder}', --python is executed from this directory
        stopAtEntry = true,
        program = '${file}', -- This configuration will launch the current file if used.
        justMyCode = false,
        pythonPath = function()
          -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
          -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
          -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
          local cwd = vim.fn.getcwd()
          if vim.env.VIRTUAL_ENV ~= nil and vim.fn.executable(vim.env.VIRTUAL_ENV .. '/bin/python') == 1 then
            return vim.env.VIRTUAL_ENV .. '/bin/python'
          elseif vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            return cwd .. '/.venv/bin/python'
          elseif vim.fn.executable '/usr/bin/python3' == 1 then
            return '/usr/bin/python3'
          else
            return '/usr/bin/python'
          end
        end,
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      layouts = {
        {
          elements = {
            {
              id = 'scopes',
              size = 0.3,
            },
            {
              id = 'breakpoints',
              size = 0.3,
            },
            {
              id = 'stacks',
              size = 0.3,
            },
          },
          position = 'left',
          size = 20,
        },
        {
          elements = { {
            id = 'repl',
            size = 1.0,
          } },
          position = 'bottom',
          size = 10,
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
    vim.keymap.set('n', '<leader>k', '<Cmd>lua require("dapui").eval()<CR>', { desc = 'Debug: Hover debug values', noremap = true, silent = true })
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup()
  end,
}
