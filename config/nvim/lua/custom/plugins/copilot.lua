-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    "github/copilot.vim",
    dependencies = {
    },

    config = function()
        local opts = { desc = "Toggle Copilot" }
        vim.api.nvim_set_keymap("n", "<Leader>bc", "<cmd>ToggleCopilot<cr>", opts)
    end,

}
