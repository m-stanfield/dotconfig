-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    },

    config = function()
        local harpoon = require("harpoon")

        -- REQUIRED
        harpoon:setup({})
        -- REQUIRED

        vim.keymap.set("n", "<leader>t", function() harpoon:list():append() end)
        vim.keymap.set("n", "<A-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set("n", "<A-u>", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<A-i>", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<A-o>", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<A-p>", function() harpoon:list():select(4) end)

        vim.keymap.set("n", "<A-S-u>", function() harpoon:list():removeAt(1) end)
        vim.keymap.set("n", "<A-S-i>", function() harpoon:list():removeAt(2) end)
        vim.keymap.set("n", "<A-S-o>", function() harpoon:list():removeAt(3) end)
        vim.keymap.set("n", "<A-S-p>", function() harpoon:list():removeAt(4) end)

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<A-S-P>", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<A-S-N>", function() harpoon:list():next() end)

        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

        vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
            { desc = "Open harpoon window" })
    end,

}
