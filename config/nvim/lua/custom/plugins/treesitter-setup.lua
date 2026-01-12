-- modified version of code from this config
--https://github.com/fredrikaverpil/dotfiles/blob/main/nvim-fredrik/lua/fredrik/plugins/core/treesitter.lua
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    opts = {
      -- custom handling of parsers
      ensure_installed = {
        'go',
        'bash',
        'c',
        'css',
        'diff',
        'gomod',
        'gowork',
        'gosum',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'json5',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
    },
    config = function(_, opts)
      require('nvim-treesitter').install(ensure_installed)
      for _, parser in ipairs(opts.ensure_installed) do
        vim.api.nvim_create_autocmd('FileType', {
          pattern = parser,
          callback = function()
            vim.treesitter.start()
          end,
        })
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
