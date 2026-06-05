-- Setup for Fuzz finder across multiple files

return {
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
                    layout_strategy = "center",
                    layout_config = {
                        center = {
                            width = 0.7,
                            height = 0.65,
                        },
                    },
                    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                },
                pickers = {
                    find_files = {
                        previewer = true,
                        cwd = vim.fn.expand("~"),
                    },
                    buffers = {
                        previewer = false,
                    },

                    live_grep = {
                        previewer = true,
                        cwd = vim.fn.expand("~"),
                    }
                }
            })
            telescope.load_extension('fzf')
            require('sarveshtikekar.plugins.telescope_ff.remaps')
        end
}
