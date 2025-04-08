return {
  'github/copilot.vim',
  dependencies = {},
  config = function()
    local opts = { desc = 'Toggle Copilot' }
    vim.api.nvim_set_keymap('n', '<Leader>bc', '<cmd>ToggleCopilot<cr>', opts)
  end,
}
