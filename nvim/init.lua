require("sarveshtikekar.remaps")

-- Entry point for lazy plugins (To be always loaded first)
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

require("lazy").setup("sarveshtikekar.plugins", {

	ui = {open = "none"}
})

--Glob declaration for ease
local global = vim.g

--For themes
vim.opt.termguicolors = true

-- For themes
local themeList = require("sarveshtikekar.ui.themeList")
global.themeCount = #(themeList.themes)
vim.cmd("colorscheme " .. "moonfly")
global.currThemeNumber = 6

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Main Entry to our Ricing setup
require("sarveshtikekar.lsp").setup()
require("sarveshtikekar.branches")

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 0 then
            require("sarveshtikekar.landing_page.land_page").show()
	    vim.wo.relativenumber = false
        end
    end,
})

-- Some global settings for checkpointing across sessions

vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.undoreload = 10000

-- Lualine Config import
require("sarveshtikekar.lualine_config")

-- For autocompletions
require("sarveshtikekar.autocompletions")

require('sarveshtikekar.config.autocmds')

-- For SarVim window UI
local sarvimUI = vim.api.nvim_create_augroup("SarVimUI", {clear = true})

-- 2. Reliable Auto-Close when the main buffer is deleted
vim.api.nvim_create_autocmd("BufDelete", {
    group = sarvimUI,
    callback = function()
        vim.schedule(function()
            local count = 0
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) and 
                   vim.bo[buf].buftype == "" and 
                   vim.bo[buf].filetype ~= "" then
                    count = count + 1
                end
	end
        end)
    end,
})


-- Some optimisation settings
vim.api.nvim_create_autocmd("BufEnter", {
	
	callback = function()
		vim.wo.relativenumber = true
	end,
})

--Browser related optimisations
vim.ui.open = function(path)

  local browser = "google-chrome" 
  local cmd = string.format("nohup %s --new-window '%s' > /dev/null 2>&1 &", browser, path) 

  os.execute(cmd)
end
