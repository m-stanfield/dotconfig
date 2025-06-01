-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'J', 'mzJ`z')
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>qq', 'qa', { desc = 'Quit Nvim' })

-- navigation keymaps
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move down half-page and center cursor' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move up half-page and center cursor' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Search next, center, and select line' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Reverse search next, center, and select line' })

vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste without overriding buffer' })
vim.keymap.set('n', '<leader>df', '<Cmd>Format<CR>', { desc = 'Format' })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<A-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<A-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<A-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<A-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move Lines
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- moving between buffers
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Test' })
-- Better Indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- [[ Neo-tree Keymaps ]]
-- Toggle Neo-tree with <leader>e
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'Toggle Neo-tree' })

-- Reveal current file in Neo-tree with <leader>o
vim.keymap.set('n', '<leader>o', '<cmd>Neotree reveal<cr>', { desc = 'Reveal file in Neo-tree' })

-- Common file operations in Neo-tree
vim.keymap.set('n', '<leader>nf', '<cmd>Neotree focus<cr>', { desc = 'Focus Neo-tree window' })
vim.keymap.set('n', '<leader>nr', '<cmd>Neotree refresh<cr>', { desc = 'Refresh Neo-tree' })

-- File manipulations
vim.keymap.set('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })
--
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- vim: ts=2 sts=2 sw=2 et
