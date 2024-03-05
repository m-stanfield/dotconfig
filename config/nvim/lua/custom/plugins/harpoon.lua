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

        vim.keymap.set("n", "<leader>H", function() harpoon:list():append() end, { desc = "Append" })
        vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = " Menu" })

        vim.keymap.set("n", "<A-u>", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<A-i>", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<A-o>", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<A-p>", function() harpoon:list():select(4) end)

        vim.keymap.set("n", "<A-S-u>", function() harpoon:list():removeAt(1) end)
        vim.keymap.set("n", "<A-S-i>", function() harpoon:list():removeAt(2) end)
        vim.keymap.set("n", "<A-S-o>", function() harpoon:list():removeAt(3) end)
        vim.keymap.set("n", "<A-S-p>", function() harpoon:list():removeAt(4) end)

        vim.keymap.set("n", "<A-S-P>", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<A-S-N>", function() harpoon:list():next() end)

        vim.keymap.set("n", "<leader>hu", function() harpoon:list():select(1) end, { desc = "Add 1" })
        vim.keymap.set("n", "<leader>hi", function() harpoon:list():select(2) end, { desc = "Add 2" })
        vim.keymap.set("n", "<leader>ho", function() harpoon:list():select(3) end, { desc = "Add 3" })
        vim.keymap.set("n", "<leader>hp", function() harpoon:list():select(4) end, { desc = "Add 4" })

        vim.keymap.set("n", "<leader>hU", function() harpoon:list():removeAt(1) end, { desc = "Rem 1 " })
        vim.keymap.set("n", "<leader>hI", function() harpoon:list():removeAt(2) end, { desc = "Rem 2" })
        vim.keymap.set("n", "<leader>hO", function() harpoon:list():removeAt(3) end, { desc = "Rem 3" })
        vim.keymap.set("n", "<leader>hP", function() harpoon:list():removeAt(4) end, { desc = "Rem 4" })


        vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "[P]rev" })
        vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "[N]ext" })
        -- Toggle previous & next buffers stored within Harpoon list

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
