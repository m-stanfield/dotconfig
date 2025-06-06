-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
  },

  config = function()
    local null_ls = require 'null-ls'

    local group = vim.api.nvim_create_augroup('lsp_format_on_save', { clear = false })
    local event = 'BufWritePre' -- or "BufWritePost"
    local async = event == 'BufWritePost'

    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.prettierd.with {
          extra_args = { '--single-quote', '--jsx-single-quote', '--print-width', '120', '--tab-width', '2' },
        },
        null_ls.builtins.formatting.stylua,
        --  null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
        -- python
        null_ls.builtins.formatting.black.with {
          extra_args = { '--line-length=120' },
        },
        null_ls.builtins.formatting.isort.with {
          extra_args = { '--profile', 'black' },
        },
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports_reviser,
        null_ls.builtins.formatting.golines,
      },

      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.keymap.set('n', '<Leader>ff', function()
            vim.lsp.buf.format { bufnr = vim.api.nvim_get_current_buf() }
          end, { buffer = bufnr, desc = '[lsp] format' })

          -- format on save
          vim.api.nvim_clear_autocmds { buffer = bufnr, group = group }
          vim.api.nvim_create_autocmd(event, {
            buffer = bufnr,
            group = group,
            callback = function()
              vim.lsp.buf.format { bufnr = bufnr, async = async }
            end,
            desc = '[lsp] format on save',
          })
        end

        if client.supports_method 'textDocument/rangeFormatting' then
          vim.keymap.set('x', '<Leader>ff', function()
            vim.lsp.buf.format { bufnr = vim.api.nvim_get_current_buf() }
          end, { buffer = bufnr, desc = '[lsp] format' })
        end
      end,
    }
  end,
}
