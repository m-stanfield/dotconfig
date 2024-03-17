-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  "MunifTanjim/prettier.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "jose-elias-alvarez/null-ls.nvim"
  },

  confgg = function()
    local prettier = require("prettier")

    prettier.setup({
      bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
      filetypes = {
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
      },
    })
  end,

}
