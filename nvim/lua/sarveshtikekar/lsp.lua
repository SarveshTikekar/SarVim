local M = {}

function M.setup()

	require("mason").setup({
        	ui = { border = "rounded" },
    	})

	require("mason-lspconfig").setup({
        	ensure_installed = {},      
        	automatic_installation = false,
    	})

	local lspconfig = require("lspconfig")
end

return M
