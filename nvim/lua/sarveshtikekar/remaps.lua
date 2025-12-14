-- Importing some utilities
local stdk = require('sarveshtikekar.stdkeys')

--Keyleader for my setup
vim.g.mapleader = " "

--Some important variables

local ent = stdk.ent
local esc = stdk.esc
local bspace = stdk.bspace
local global = vim.g

-- User defined modules / tables
local themeList = require("sarveshtikekar.themeList")
-- Explorer remaps
vim.keymap.set("n", "<leader>z", function()
	vim.cmd("Ex")
end, {silent = true})
						-- Neovim Editor keymaps

-- Set / reset line numbers
vim.keymap.set({'v', 'n'}, "ln", ":set nu" .. ent, {noremap = true, silent=true})
vim.keymap.set({'v', 'n'}, "nl", ":set nonumber" .. ent, {noremap = true, silent = true})

-- Set / Reset relative line numbers
vim.keymap.set({'v', 'n'}, "ln", ":set nu" .. ent, {noremap = true, silent=true})

-- Screenshot yank (Selecting entire file text)
vim.keymap.set({'v', 'n'}, "syk", function()

	vim.cmd("normal! ggVG")
	vim.cmd('normal! "+y')
	vim.notify("Screenshot yank successfull to keyboard")

end, {noremap = true, silent = true, desc="Screenshot yank"})

-- Screenshot current line (Copy current line)

vim.keymap.set({'v', 'n'}, "dy", function()
	local lineNumber = vim.api.nvim_win_get_cursor(0)[1]
	vim.cmd("normal! V")
	vim.cmd('normal! "+y')
	vim.notify("Line " .. lineNumber .. " yanked successfully")
end, {noremap=true, silent=true})

-- Screenshot any line given (Copy any single line from text)

vim.keymap.set({'v', 'n'}, "ly", function()

	local reqdLine = tonumber(vim.fn.input("Line: "))
	vim.api.nvim_win_set_cursor(0, {reqdLine, 1})

	if reqdLine then
		vim.cmd("normal! V")
		vim.cmd('normal! "+y')
		vim.notify("Line " .. reqdLine .. " yanked successfully")
	end
end, {noremap=true, silent=true})

-- Screenshot Line range
vim.keymap.set({'v', 'n'}, "rly", function() 

	local lineString = vim.fn.input("")
	local startLine, endLine = lineString:match("(%d+)%-(%d+)")
	
	startLine, endLine = tonumber(startLine), tonumber(endLine)
	-- If anyline is missing report an error
	if not startLine or not endLine then 
		vim.notify("Line number(s) is/are invalid")
	end

	-- Swap line-nos if start > end
	
	if startLine > endLine then 
		startLine, endLine = endLine, startLine
	end

	vim.api.nvim_win_set_cursor(0, {startLine, 1})
	vim.cmd("normal! V" .. (endLine - startLine) .. "j")
	vim.cmd("normal! \"+y")
	vim.notify("Lines " .. startLine .. " to " ..endLine .. " yanked successfully")

end, {noremap=true, silent=true})

-- Normal save
vim.keymap.set({'n'}, "sv", ":w" .. ent, {noremap=true})

-- Save + quit
vim.keymap.set({'n'}, "sq", ":wq!" .. ent, {noremap=true})

-- Branching keymaps
vim.keymap.set("n", "cub", function()
    local buf = vim.api.nvim_get_current_buf()
    local branches = require("sarveshtikekar.branches")
    local curr = branches.get_active_branch()

    vim.notify(
        "buf=" .. buf ..
        " name=" .. vim.api.nvim_buf_get_name(buf) ..
        " branch=" .. tostring(curr)
    )
end)

-- Theme toggler (Incremental)
vim.keymap.set({'n', 'v'}, "tg", function() 
	local themes = require("sarveshtikekar.themeList").themes
	global.currThemeNumber = (global.currThemeNumber + 1) % (global.themeCount + 1)

	if global.currThemeNumber == 0 then 	
		global.currThemeNumber = global.currThemeNumber + 1
	end

	vim.cmd("colorscheme " .. themes[global.currThemeNumber])
	vim.notify("The current theme is: " ..themes[global.currThemeNumber])
end, {noremap=true})

-- Theme toggler (Decremental)
vim.keymap.set({'n', 'v'}, "gt", function() 
	local themes = require("sarveshtikekar.themeList").themes
	global.currThemeNumber = (global.currThemeNumber - 1)

	if global.currThemeNumber == 0 then
		global.currThemeNumber = global.themeCount
	end

	vim.cmd("colorscheme " .. themes[global.currThemeNumber])
	vim.notify("The current theme is: " ..themes[global.currThemeNumber])
end, {noremap=true})
