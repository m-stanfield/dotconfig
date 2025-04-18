-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local teleactions = require("telescope.actions")
require('telescope').setup {
  defaults = {
    file_ignore_patterns = { "node_modules", ".venv", "/usr" },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<CR>"] = teleactions.select_default + teleactions.center,
      },
      n = {
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = { git_root },

    })
  end
end

local function live_git_root()
  local git_root = find_git_root()
  local isgit = vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1]
  if isgit == "true" then
    return require('telescope.builtin').git_files({})
  else
    return require('telescope.builtin').find_files({ hidden = false })
  end
end


vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

vim.api.nvim_create_user_command('LiveGitRoot', live_git_root, {})
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[F]ind existing [b]uffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader><space>', ':LiveGitRoot<cr>', { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [f]iles' })
vim.keymap.set('n', '<leader>sF', function()
    require('telescope.builtin').find_files({ hidden = false, no_ignore = true })
  end,
  { desc = '[S]earch All [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').lsp_document_symbols,
  { desc = '[S]earch Document [S]ymbols' })
vim.keymap.set('n', '<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols,
  { desc = '[S]earch Workspace [S]ymbols' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', function() require('telescope.builtin').diagnostics({ bufnr = 0, }) end,
  { desc = '[S]earch local [d]iagnostics' })
vim.keymap.set('n', '<leader>sD', require('telescope.builtin').diagnostics, { desc = '[S]earch workspace [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })



-- vim: ts=2 sts=2 sw=2 et
