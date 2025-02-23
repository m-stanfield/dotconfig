-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  "danymat/neogen",

  config = function()
    local neogen = require("neogen")
    neogen.setup {
      enabled = true,
      languages = {
        python = {
          template = {
            annotation_convention = "numpydoc"
          }
        },
      }
    }
    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap("n", "<Leader>dc", ":lua require('neogen').generate()<CR>", opts)
    return true
  end

}
