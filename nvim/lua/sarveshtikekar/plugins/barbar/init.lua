-- Plugin settings for barbar

return {

    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {

	    animation=true, tabpages=true, clickable=true, focus_on_close='right',
	    highlight_visible=true,

	    separator = {left = '| ', right= '|'},
	    modified = {button = '⟲'},
	    maximum_length = 20
    },
    version = '^1.0.0',
}
