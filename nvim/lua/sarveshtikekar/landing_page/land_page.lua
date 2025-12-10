local M = {}

function M.show()
    -----------------------------------------------------------
    -- MULTILINE ASCII ART (clean + readable)
    -----------------------------------------------------------
    local ascii = [[
                                                                                         
         ______         ____        _____    ____      ____  ____      ______  _______   
     ___|\     \   ____|\   \   ___|\    \  |    |    |    ||    |    |      \/       \  
    |    |\     \ /    /\    \ |    |\    \ |    |    |    ||    |   /          /\     \ 
    |    |/____/||    |  |    ||    | |    ||    |    |    ||    |  /     /\   / /\     |
 ___|    \|   | ||    |__|    ||    |/____/ |    |    |    ||    | /     /\ \_/ / /    /|
|    \    \___|/ |    .--.    ||    |\    \ |    |    |    ||    ||     |  \|_|/ /    / |
|    |\     \    |    |  |    ||    | |    ||\    \  /    /||    ||     |       |    |  |
|\ ___\|_____|   |____|  |____||____| |____|| \ ___\/___ / ||____||\____\       |____|  /
| |    |     |   |    |  |    ||    | |    | \ |   ||   | / |    || |    |      |    | / 
 \|____|_____|   |____|  |____||____| |____|  \|___||___|/  |____| \|____|      |____|/  
    \(    )/       \(      )/    \(     )/      \(    )/      \(      \(          )/     
     '    '         '      '      '     '        '    '        '       '          '      
                                                                                        

	Welcome to SarVim, Sarvesh's personal Neovim + Tmux ricing setup
	Currently under development :)
				
]]

    -----------------------------------------------------------
    -- Convert ASCII multiline string into table of lines
    -----------------------------------------------------------
    local ascii_lines = {}
    for line in ascii:gmatch("[^\n]+") do
        table.insert(ascii_lines, line)
    end

    -- Add footer text
    table.insert(ascii_lines, "")

    -----------------------------------------------------------
    -- Create a new empty buffer
    -----------------------------------------------------------
    vim.cmd("enew")
    vim.opt_local.modifiable = true
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false

    -----------------------------------------------------------
    -- Get window size (terminal size)
    -----------------------------------------------------------
    local ui = vim.api.nvim_list_uis()[1]
    local win_height = ui.height
    local win_width = ui.width

    -----------------------------------------------------------
    -- Compute vertical centering
    -----------------------------------------------------------
    local ascii_height = #ascii_lines
    local top_padding = math.floor((win_height - ascii_height) / 2)

    local empty_lines = {}
    for _ = 1, top_padding do
        table.insert(empty_lines, "")
    end

    -----------------------------------------------------------
    -- Apply horizontal centering to each ASCII line
    -----------------------------------------------------------
    local centered_ascii = {}
    for _, line in ipairs(ascii_lines) do
        local pad = math.floor((win_width - #line) / 2)
        local padded_line = string.rep(" ", pad) .. line
        table.insert(centered_ascii, padded_line)
    end

    -----------------------------------------------------------
    -- Merge vertical padding + horizontally centered ASCII
    -----------------------------------------------------------
    local final_content = vim.list_extend(empty_lines, centered_ascii)

    -----------------------------------------------------------
    -- Write to buffer
    -----------------------------------------------------------
    vim.api.nvim_buf_set_lines(0, 0, -1, false, final_content)

    -----------------------------------------------------------
    -- Make the buffer read-only and auto-remove
    -----------------------------------------------------------
    -- Make the buffer behave like a dashboard
	vim.bo.modifiable     = false
	vim.bo.bufhidden      = "wipe"
	vim.bo.buftype        = "nofile"
	vim.bo.swapfile       = false
	vim.bo.buflisted      = false

	vim.keymap.set("n", "<CR>", function()
    	vim.cmd("bd!")  -- wipe dashboard
    	vim.cmd("Ex")   -- open netrw
end, { buffer = true, silent = true })
vim.opt.fillchars:append({ eob = " " })
end

return M

