local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#080808',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#d183e8',
  grey   = '#303030',
  tail_cyan = '#ade8f4',
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.tail_cyan, bg = colors.grey },
    b = { fg = colors.tail_cyan, bg = colors.grey },
    c = { fg = colors.tail_cyan },
  },
  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white },
  },
}

require('lualine').setup {
  options = {
    theme = bubbles_theme,
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = { {'filename'}, {'branch', icon = '\u{e0a0}', color = {gui = 'bold'}}}, 
    lualine_c = {
	
	    --Branch info for local checkpoint tree
	{function() 
		return require("sarveshtikekar.branches").get_active_branch()
	end, 
	icon = "󰙅", color = {fg = colors.tail_cyan, bg = colors.grey, gui = 'bold'},
    },
    	-- Function to display current checkpoint on branch
	{function() 	
		return require("sarveshtikekar.branches").get_active_checkpoint()
	end, icon="", color = {fg = colors.tail_cyan, bg = colors.grey, gui = 'bold'},
    }},
    lualine_x = {{
	    function()
		return require("sarveshtikekar.themeList").themes[vim.g.currThemeNumber]
    	end, icon='\u{ed32}', color = {fg = colors.tail_cyan, bg = colors.grey}}},

    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
}
