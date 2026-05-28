-- Remaps for barbar config

local map = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

-- Tab switching
map('n', '<S-l>', '<Cmd>BufferNext<CR>', opts)
map('n', '<S-h>', '<Cmd>BufferPrevious<CR>', opts)

-- Tab closing
map('n', '<C-w>', '<Cmd>BufferClose<CR>', opts)

-- Open file as new tab (via Telescope)
-- Opening any file automatically creates a new barbar tab
map('n', '<C-t>', '<Cmd>Telescope find_files<CR>', opts)

-- Switch between open tabs via Telescope
map('n', '<C-b>', '<Cmd>Telescope buffers<CR>', opts)

-- New empty tab
map('n', '<C-n>', '<Cmd>enew<CR>', opts)
