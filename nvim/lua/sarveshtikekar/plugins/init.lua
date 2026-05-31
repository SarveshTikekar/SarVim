
-- Global Plugins file for SarVim

-- Import all required plugins
local forkyou = require("sarveshtikekar.plugins.forkyou")
local barbar = require("sarveshtikekar.plugins.barbar")
local cyberdream = require("sarveshtikekar.plugins.cyberdream_theme")
local neoscroll = require("sarveshtikekar.plugins.neoscroll")
local telescope = require("sarveshtikekar.plugins.telescope_ff")
local copilot = require("sarveshtikekar.plugins.copilot")

return {

-- Mason LSP
    	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
    	"neovim/nvim-lspconfig",
	{"neanias/everforest-nvim", priority = 1000},
	cyberdream,
	neoscroll,
	{"hrsh7th/nvim-cmp", dependencies={
		"hrsh7th/cmp-nvim-lsp"
	}},

	{"mbbill/undotree", cmd="UndotreeToggle"},
	{'nvim-lualine/lualine.nvim',
    		dependencies = {'nvim-tree/nvim-web-devicons'}},

    	{"L3MON4D3/LuaSnip",
		tag = "v2.4.1",
		run = "make install_jsregexp"},
	
	telescope,
    	{"rachartier/tiny-inline-diagnostic.nvim",
    	event = "VeryLazy",
    	priority = 1000,
    	config = function()
        	require("tiny-inline-diagnostic").setup({

			preset = "minimal",
			hi={
				error="DiagnosticError",
				warn="DiagnosticWarn",
				mixing_color="Normal",
			},

			options={
				show_source = {
					enabled = true,
				},
			},
		})
        vim.diagnostic.config({ virtual_text = false }) 
    	end,
    },

    {

	 'nvim-treesitter/nvim-treesitter',
    	-- Remove 'branch = "master"' if it exists, use 'main' as default
    	build = ':TSUpdate', -- This ensures the parsers are installed
    	opts = {
        	ensure_installed = { 'lua', 'vim', 'javascript' }, -- Add your languages
        	highlight = { enable = true },
        	indent = { enable = true },
	}
     },

     -- For barbar
     barbar,

     -- For copilot
     copilot,

     -- For ForkYou
     forkyou,
}
