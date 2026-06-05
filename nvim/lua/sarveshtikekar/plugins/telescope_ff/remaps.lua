 -- Remaps for Telescope

local keymap = vim.keymap.set
local opts = {noremap = true, silent = true}

keymap('n', '<leader>gl', function()
    require("telescope.builtin").live_grep({ cwd = vim.fn.expand("~") })
end, opts)
