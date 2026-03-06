-- neotest: Framework for running tests interactively
-- Run individual tests, view results inline, debug failing tests
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'fredrikaverpil/neotest-golang',
    'nvim-neotest/neotest-python',
  },

  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-golang' {},
        require 'neotest-python' {
          dap = { justMyCode = false }, -- Enables debugging into library code
        },
      },
    }

    -- Keymaps under <leader>t for [T]est
    vim.keymap.set('n', '<leader>tn', function()
      require('neotest').run.run()
    end, { desc = '[T]est [N]earest' })
    vim.keymap.set('n', '<leader>tf', function()
      require('neotest').run.run(vim.fn.expand '%')
    end, { desc = '[T]est [F]ile' })
    vim.keymap.set('n', '<leader>ts', function()
      require('neotest').summary.toggle()
    end, { desc = '[T]est [S]ummary' })
    vim.keymap.set('n', '<leader>to', function()
      require('neotest').output.open { enter = true }
    end, { desc = '[T]est [O]utput' })
    vim.keymap.set('n', '<leader>tp', function()
      require('neotest').output_panel.toggle()
    end, { desc = '[T]est [P]anel' })
    vim.keymap.set('n', '<leader>tl', function()
      require('neotest').run.run_last()
    end, { desc = '[T]est [L]ast' })
    vim.keymap.set('n', '<leader>td', function()
      require('neotest').run.run { strategy = 'dap' }
    end, { desc = '[T]est [D]ebug nearest' })
    vim.keymap.set('n', '<leader>tx', function()
      require('neotest').run.stop()
    end, { desc = '[T]est Stop' })

    -- Jump between tests
    vim.keymap.set('n', '[t', function()
      require('neotest').jump.prev { status = 'failed' }
    end, { desc = 'Previous failed test' })
    vim.keymap.set('n', ']t', function()
      require('neotest').jump.next { status = 'failed' }
    end, { desc = 'Next failed test' })
  end,
}
