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
            c = { fg = colors.white, bg = bgc },
        },
        inactive = {
            a = { fg = colors.white, bg = bgc },
            b = { fg = colors.white, bg = bgc },
            c = { fg = colors.white, bg = bgc },
        },
    }

    local sep = { function() return '❮' end, color = { fg = '#D4AF37', bg = bgc }, padding = 0}

    require('lualine').setup {
        options = {
            theme = bubble_theme,
            component_separators = '',
            section_separators   = '',
        },
        sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},

            -- Right side: gold ❯ between every component
            lualine_x = {
                { 'mode' },
                sep,
                { 'filename' },
                sep,
                { function()
                    return require("sarveshtikekar.branches").get_active_branch()
                  end,
                  color = { fg = colors.white, bg = bgc, gui = 'bold' },
                },
                sep,
                { function()
                    return require("sarveshtikekar.branches").get_active_checkpoint()
                  end,
                  color = { fg = colors.white, bg = bgc, gui = 'bold' },
                },
            },
            lualine_y = {
                sep,
                'filetype',
            },
            lualine_z = {
                sep,
                'location',
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = { 'filename' },
            lualine_y = {},
            lualine_z = { 'location' },
        },
    }

    -- Force transparent statusline — lualine doesn't clear Neovim's
    -- StatusLine hl group, which fills the bar with the theme's bg color.
    vim.api.nvim_set_hl(0, 'StatusLine',   { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE' })
end

vim.schedule(setup_lualine) -- deferred so apply_transparency() in init.lua runs first

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "ColorScheme" }, {
    callback = function()
        -- Defer so apply_transparency() always runs first,
        -- ensuring color_adjuster reads Normal.bg correctly
        vim.schedule(function()
            setup_lualine()
        end)
    end
})

