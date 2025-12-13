-- Plugins for nvim

return {

-- Mason LSP

    	"williamboman/mason.nvim",       
	"williamboman/mason-lspconfig.nvim",  
    	"neovim/nvim-lspconfig",
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    	{ "ellisonleao/gruvbox.nvim", priority = 1000 },

    	{ "savq/melange-nvim", priority = 1000 },

    	{ "vague2k/vague.nvim", priority = 1001 },
	{ "rose-pine/neovim", name = "rose-pine" },
}
