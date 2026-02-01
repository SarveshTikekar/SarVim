local function setup_lualine()
    local ca = require('sarveshtikekar.lualine_config.color_adjuster')
    local bgc = ca.color_adjust()

    local colors = {
        blue      = '#80a0ff',
        cyan      = '#79dac8',
        black     = '#080808',
        white     = '#c6c6c6',
        red       = '#ff5189',
        violet    = '#d183e8',
        grey      = '#303030',
        tail_cyan = '#ade8f4',
    }

    local bubble_theme = {
        normal = {
            a = { fg = colors.white, bg = bgc },
            b = { fg = colors.white, bg = bgc },
            c = { fg = colors.white, bg = bgc }, -- Added bgc for continuity
        },
        inactive = {
            a = { fg = colors.white, bg = bgc },
            b = { fg = colors.white, bg = bgc },
            c = { fg = colors.white, bg = bgc },
        },
    }

    require('lualine').setup {
        options = {
            theme = bubble_theme,
            component_separators = '', 
        },
        -- SECTIONS must be out here, not inside options
        sections = {
            lualine_a = { { 'mode', separator = { right = '' }, right_padding = 2 } },
            lualine_b = { {'filename'}, {'branch', icon = '', color = {gui = 'bold'}}}, 
            lualine_c = {
                { function() 
                    return require("sarveshtikekar.branches").get_active_branch()
                  end, 
                  icon = "󰙅", color = {fg = colors.white, bg = bgc, gui = 'bold'},
                },
                { function()     
                    return require("sarveshtikekar.branches").get_active_checkpoint()
                  end, 
                  icon="", color = {fg = colors.white, bg = bgc, gui = 'bold'},
                }
            },
            lualine_x = {
                { function()
                    return require("sarveshtikekar.ui.themeList").themes[vim.g.currThemeNumber]
                  end, 
                  icon='', color = {fg = colors.white, bg = bgc}
                }
            },
            lualine_y = { 'filetype', 'progress' },
            lualine_z = {
                { 'location',  left_padding = 2 },
            },
        },
        inactive_sections = {
            lualine_a = { 'filename' },
            lualine_z = { 'location' },
        },
    }
end

setup_lualine()

vim.api.nvim_create_autocmd({"BufEnter", "WinEnter", "ColorScheme"}, {
    callback = function()
	setup_lualine()
    end
})
