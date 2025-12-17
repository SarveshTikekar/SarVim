local M = {}
local timer = nil

M.get_dev_quotes = function()
    local script_path = debug.getinfo(1).source:sub(2)
    local dir = vim.fn.fnamemodify(script_path, ":h")
    local path = dir .. "/quotes.txt"
    if vim.fn.filereadable(path) == 0 then return { '"It\'s all talk until the code runs."' } end
    local quote_lines = vim.fn.systemlist("grep '\"' " .. vim.fn.shellescape(path))
    return (#quote_lines > 0) and quote_lines or { '"It\'s all talk until the code runs."' }
end

local function get_system_info()
    local cpu = vim.fn.system([[grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}']]):gsub("%s+", "")
    local ram = vim.fn.system([[free -m | awk '/Mem:/ { print $3"/"$2"MB" }']]):gsub("%s+", "")
    local disk = vim.fn.system([[df -h / | awk 'NR==2 {print $5}']]):gsub("%s+", "")
    local uptime = vim.fn.system([[uptime -p | sed "s/up //; s/ hours\?/h/; s/ minutes\?/m/; s/ days\?/d/"]]):gsub("%s+", "")
    return { 
        cpu = (tonumber(cpu) and string.format("%.1f%%", tonumber(cpu))) or "N/A", 
        ram = ram, 
        disk = disk, 
        uptime = uptime 
    }
end

local function get_git_stats()
    local user = vim.fn.system("git config user.name"):gsub("%s+", "")
    local stats_cmd = [[
        total=0; today=0
        for g in $(find ~ -maxdepth 4 -type d -name ".git" 2>/dev/null); do
            repo=$(dirname $g)
            c=$(git -C "$repo" rev-list --count HEAD --author="]] .. user .. [[" 2>/dev/null)
            total=$((total + ${c:-0}))
            t=$(git -C "$repo" rev-list --count HEAD --author="]] .. user .. [[" --since="midnight" 2>/dev/null)
            today=$((today + ${t:-0}))
        done
        echo "$total|$today"
    ]]
    local output = vim.fn.system(stats_cmd):gsub("%s+", "")
    local t_comm, d_comm = output:match("([^|]+)|([^|]+)")
    return { total = t_comm or "0", today = d_comm or "0" }
end

function M.show()
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

]]

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    local ns_id = vim.api.nvim_create_namespace("SarVimDash")
    local ui = vim.api.nvim_list_uis()[1]
    local win_h, win_w = ui.height, ui.width

    local canvas = {}
    for i = 1, win_h do table.insert(canvas, "") end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, canvas)

    local ascii_lines = vim.fn.split(ascii, "\n")
    local start_row = math.floor((win_h - #ascii_lines) / 2) - 2
    local split_col = math.floor(win_w * 0.85) 

    local git = get_git_stats()

    local function update_ui()
        if not vim.api.nvim_buf_is_valid(buf) then
            if timer then timer:stop(); timer:close(); timer = nil end
            return
        end

        -- Update Date + Timer (TOP LEFT)
        local time_str = " " .. os.date("%B %d │ %H:%M:%S")
        vim.api.nvim_buf_set_extmark(buf, ns_id, 0, 0, {
            virt_text = {{time_str, "PmenuSel"}},
            virt_text_pos = "overlay",
            id = 1
        })

        local sys = get_system_info()
        
        -- Structured sidebar with vertical spacing and closed regions
        local sidebar = {
            [0] = { " System Info ", "Identifier" },
            [1] = { " CPU: " .. sys.cpu, "Special" },
            [2] = { " RAM Usage: " .. sys.ram, "Special" },
            [3] = { " DSK Usage: " .. sys.disk, "Special" },
            [4] = { " Uptime: " .. sys.uptime, "Special" },
            [5] = { "──────────────", "Comment" }, -- Closed System Region
            [7] = { " Dev Info  ", "Identifier" },
            [8] = { " Commits today: " .. git.today, "Special" },
            [9] = { " Total Commits: " .. git.total, "Special" },
            [10] = { "──────────────", "Comment" } -- Closed Git Region
        }

        -- Draw sidebar content and vertical divider
        -- Span slightly longer than content to ensure visual closure
        for i = 0, 12 do
            local row = start_row + i
            if row < win_h then
                -- Vertical Divider
                vim.api.nvim_buf_set_extmark(buf, ns_id, row, 0, {
                    virt_text = {{ "│", "Comment" }},
                    virt_text_pos = "overlay",
                    virt_text_win_col = split_col,
                    id = 10 + i
                })
                -- Sidebar Text
                if sidebar[i] then
                    vim.api.nvim_buf_set_extmark(buf, ns_id, row, 0, {
                        virt_text = { sidebar[i] },
                        virt_text_pos = "overlay",
                        virt_text_win_col = split_col + 3,
                        id = 100 + i
                    })
                end
            end
        end
    end

    -- Draw Logo
    for i, line in ipairs(ascii_lines) do
        local pad = math.floor((win_w - #line) / 2)
        local row = start_row + i
        if row < win_h then
            vim.api.nvim_buf_set_lines(buf, row, row + 1, false, {string.rep(" ", pad) .. line})
            vim.api.nvim_buf_add_highlight(buf, ns_id, "Identifier", row, 0, -1)
        end
    end

    -- Draw Quote (Centered at bottom)
    local quotes = M.get_dev_quotes()
    local quote = quotes[math.random(#quotes)]
    local q_row = win_h - 4
    if q_row < win_h then
        vim.api.nvim_buf_set_lines(buf, q_row, q_row + 1, false, {string.rep(" ", math.floor((win_w - #quote)/2)) .. quote})
        vim.api.nvim_buf_add_highlight(buf, ns_id, "Comment", q_row, 0, -1)
    end

    if timer then timer:stop(); timer:close() end
    timer = vim.loop.new_timer()
    timer:start(0, 1000, vim.schedule_wrap(update_ui))

    vim.keymap.set("n", "<CR>", function()
        if timer then timer:stop(); timer:close(); timer = nil end
        vim.cmd("bd!")
        vim.cmd("Explore")
    end, { buffer = buf, silent = true, nowait = true })

    vim.api.nvim_create_autocmd("BufWipeout", {
        buffer = buf,
        callback = function()
            if timer then timer:stop(); timer:close(); timer = nil end
        end
    })

    vim.bo[buf].modifiable = false
    vim.bo[buf].buftype = "nofile"
end

return M
