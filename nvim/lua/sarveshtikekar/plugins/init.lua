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
	{ "rose-pine/neovim", name = "rose-pine"},

	{'AlexvZyl/nordic.nvim', name="nordic", priority=1000},
	{"hrsh7th/nvim-cmp", dependencies={
		"hrsh7th/cmp-nvim-lsp"
	}},

	{"mbbill/undotree", cmd="UndotreeToggle"},
	{'nvim-lualine/lualine.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'}},

    {"L3MON4D3/LuaSnip",
	tag = "v2.4.1",
	run = "make install_jsregexp"},
}
