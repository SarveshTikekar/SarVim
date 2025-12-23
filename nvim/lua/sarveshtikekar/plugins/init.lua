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
	   "folke/trouble.nvim",
    opts = {
        auto_close = false,      -- Don't close when items are gone
        pinned = true,           -- Bind to the current buffer and stay open
        open_no_results = true,  -- Ensure it opens even if 0 errors
        warn_no_results = false, -- Disable the default warning to use our custom text

        modes = {
            diagnostics = {
                win = {
                    position = "bottom",
                    height = 10,
                    width = 0.7, -- Centers the HUD horizontally
                    wrap = true,
                },
                sections = {
                    {
                        -- If no results, this will show your custom string
                        type = "results",
                        text = { ["no_results"] = "No issues found" },
                    }
                },
            },
        },
        win = {
            position = "bottom",
            height = 10,
            width = 0.7,
            wrap = true,
        },
    },
    },
}
