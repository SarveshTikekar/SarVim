-- Setup for Fuzz finder across multiple files
--
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
}
