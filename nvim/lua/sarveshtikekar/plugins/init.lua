-- Plugins for nvim

local env = require("sarveshtikekar.env")
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
	{"bluz71/vim-moonfly-colors", name = "moonfly", priority = 1000},
	{"hrsh7th/nvim-cmp", dependencies={
		"hrsh7th/cmp-nvim-lsp"
	}},

	{"mbbill/undotree", cmd="UndotreeToggle"},
	{'nvim-lualine/lualine.nvim',
    		dependencies = {'nvim-tree/nvim-web-devicons'}},

    	{"L3MON4D3/LuaSnip",
		tag = "v2.4.1",
		run = "make install_jsregexp"},
    {
	'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },
        config = function()
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    entry_prefix = " ",
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.5,
                        },
                        width = 0.2,
                        height = 0.2,
                    },
                    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                },
                pickers = {
                    find_files = {
                        theme = "dropdown",
                        previewer = true,
                    },
                    buffers = {
                        theme = "dropdown",
                        previewer = false,
                    }
                }
            })
            telescope.load_extension('fzf')
        end	
    },

    {
	"rachartier/tiny-inline-diagnostic.nvim",
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
        	vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
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

     -- For Forkyou integration
     {
	"forkyoudev/forkyou.nvim",
  	config = function()
    		require("forkyou").setup({
      			api_token = env.FORKYOU_API_KEY,
    		})
  	end
     },
}
