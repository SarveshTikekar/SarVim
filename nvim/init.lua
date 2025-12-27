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
local themeList = require("sarveshtikekar.themeList")
math.randomseed(os.time())
global.themeCount = #(themeList.themes)
global.currThemeNumber = math.random(global.themeCount)
vim.cmd("colorscheme " .. themeList.themes[global.currThemeNumber])


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


-- Some global settings for checkpointing across sessions

vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.undoreload = 10000

-- Lualine Config import
require("sarveshtikekar.lualine_config")

-- For autocompletions
require("sarveshtikekar.autocompletions")

-- For SarVim window UI
local sarvimUI = vim.api.nvim_create_augroup("SarVimUI", {clear = true})

-- 1. Open Trouble on load (Pinned will keep it there)
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile"}, {
    group = sarvimUI,
    callback = function()
        if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
            vim.defer_fn(function()
                require("trouble").open({ mode = "diagnostics" })
                vim.cmd("wincmd p")
            end, 150)
        end
    end,
})

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
            
            -- Close the window only when no more code files are open
            if count == 0 then
                require("trouble").close()
            end
        end)
    end,
})

