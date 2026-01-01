local color_util = require('sarveshtikekar.lualine_config.color_adjuster')

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "trouble",
  callback = function()	
	  if vim.bo.filetype == 'trouble' then
    		vim.wo.winbar = " "
	  end
  end,
})

-- For consistent diagnostics window
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    	local bg = color_util.color_adjust(3)
    	if not bg then return end

    	vim.api.nvim_set_hl(0, "TroubleNormal",   { bg = bg })
    	vim.api.nvim_set_hl(0, "TroubleNormalNC", { bg = bg })
	vim.api.nvim_set_hl(0, "WinBar",   { bg = "#ff0000" })
	vim.api.nvim_set_hl(0, "WinBarNC", { bg = "#ff0000" })
  end,
})
