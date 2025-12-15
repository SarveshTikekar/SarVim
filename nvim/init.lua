require("sarveshtikekar.remaps")

-- Entry point for lazy plugins (To be always loaded first)
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

require("lazy").setup("sarveshtikekar.plugins", {

	ui = {open = "none"}
})


-- Main Entry to our Ricing setup
require("sarveshtikekar.lsp").setup()
require("sarveshtikekar.branches")

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 0 then
            require("sarveshtikekar.landing_page.land_page").show()
        end
    end,
})

--Glob declaration for ease

local global = vim.g

-- For themes
local themeList = require("sarveshtikekar.themeList")
math.randomseed(os.time())
global.themeCount = #(themeList.themes)
global.currThemeNumber = math.random(global.themeCount)
vim.cmd("colorscheme " .. themeList.themes[global.currThemeNumber])

--[[
vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    prefix = "●",
  },
  signs = false,
  underline = true,
  update_in_insert = false,
})

]]
