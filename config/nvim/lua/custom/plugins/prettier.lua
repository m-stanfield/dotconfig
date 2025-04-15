-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'MunifTanjim/prettier.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvimtools/none-ls.nvim',
  },

  config = function()
    local prettier = require 'prettier'

    prettier.setup {
      bin = 'prettierd', -- or `'prettier'`
      filetypes = {
        'css',
        'graphql',
        'html',
        'javascript',
        'javascriptreact',
        'json',
        'less',
        'markdown',
        'scss',
        'typescript',
        'typescriptreact',
        'yaml',
      },
      cli_options = {
        tab_width = 4, -- this is the key line
      },
    }
  end,
}
