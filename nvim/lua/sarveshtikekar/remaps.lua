						--Remaps for SarVim

-- Importing some utilities

local stdk = require('sarveshtikekar.stdkeys')

--Keyleader for my setup
vim.g.mapleader = " "

--Some important variables

local ent = stdk.ent
local esc = stdk.esc
local bspace = stdk.bspace

-- Explorer remaps
vim.keymap.set("n", "<leader>z", vim.cmd.Ex, {silent = true})

-- Neovim Editor keymaps
vim.keymap.set({'v', 'n'}, "ln", ":set nu" .. ent, {noremap = true, silent=true})
