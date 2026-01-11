local M = {}
local timer = nil

local api = vim.api
local uv  = vim.loop

local scripts = require("sarveshtikekar.scripts")
-- We use this for fallback, but main icons are hardcoded below for stability
local icons = require("sarveshtikekar.ui.icons")

-- =====================
-- 0. DEFINE COLORS
-- =====================
local function set_highlights()
  vim.api.nvim_set_hl(0, "DashGithub",    { fg = "#FFFFFF" }) -- White
  vim.api.nvim_set_hl(0, "DashLinkedin",  { fg = "#0077b5" }) -- LinkedIn Blue
  vim.api.nvim_set_hl(0, "DashX",          { fg = "#FFFFFF" }) -- X White
  vim.api.nvim_set_hl(0, "DashInstagram", { fg = "#E1306C" }) -- Instagram Pink
end
set_highlights()

-- =====================
-- 1. CONFIG & ICONS
-- =====================
local LINKS = {
  { icon = "",  hl = "DashGithub",    url = "https://github.com/SarveshTikekar" },
  { icon = "",  hl = "DashLinkedin",  url = "https://linkedin.com/in/sarveshtikekar" },
  { icon = "",   hl = "DashX",          url = "https://x.com/who_ssh" }, 
  { icon = "",   hl = "DashInstagram", url = "https://instagram.com/_sarvesh_t" },
}
local GAP_STR = "    "

-- Setup nvim-web-devicons
local has_devicons, devicons = pcall(require, "nvim-web-devicons")

local function get_lang_info(lang)
  if not has_devicons then return "", "Comment" end
  
  local name = string.lower(lang or "")
  name = name:gsub("%s+", "") -- Clean whitespace

  -- <<< FIX: Handle Special Filenames >>>
  if name == "makefile" then 
      local i, h = devicons.get_icon("Makefile", "make", { default = false })
      return i or "", h or "DevIconMake"
  elseif name == "dockerfile" then
      local i, h = devicons.get_icon("Dockerfile", "dockerfile", { default = false })
      return i or "", h or "DevIconDockerfile"
  end

  local icon, hl = devicons.get_icon_by_filetype(name, { default = false })
  if icon then return icon, hl end
  
  local icon2, hl2 = devicons.get_icon(name, "", { default = false })
  if icon2 then return icon2, hl2 end

  return "", "Comment"
end

-- =====================
-- HELPERS
-- =====================
local function read_stats_from_log()
  local path = vim.fn.expand("$HOME/.config/nvim/lua/sarveshtikekar/scripts/stats/stat-log.txt")
  if vim.fn.filereadable(path) == 0 then
    return { "0", "0", "0", "Unknown" }
  end
  
  local lines = vim.fn.readfile(path)
  -- Order: Till Date, Today, Streak, Langs
  return {
    lines[1] or "0",
    lines[2] or "0",
    lines[3] or "0",
    lines[4] or "Unknown"
  }
end

local function get_dev_quote()
  local path = vim.fn.stdpath("config") .. "/lua/sarveshtikekar/landing_page/quotes.txt"
  if vim.fn.filereadable(path) == 0 then return '"It’s all talk until the code runs."' end
  local quotes = vim.fn.systemlist("grep '\"' " .. vim.fn.shellescape(path))
  return quotes[math.random(#quotes)]
end

local function safe(fn, fallback)
  local ok, res = pcall(fn)
  if not ok or res == nil then return fallback end
  return res
end

-- =====================
-- BOX DRAWER
-- =====================
local function draw_box(buf, ns, row, col, width, lines, hl)
  local top    = "╔" .. string.rep("═", width - 2) .. "╗"
  local bottom = "╚" .. string.rep("═", width - 2) .. "╝"

  local box_lines = { top }
  for _, line in ipairs(lines) do
    local padded = line .. string.rep(" ", width - 2 - api.nvim_strwidth(line))
    table.insert(box_lines, "║" .. padded .. "║")
  end
  table.insert(box_lines, bottom)

  for i, box_str in ipairs(box_lines) do
    local r = row + i - 1
    local current_line = ""
    local ok, fetched = pcall(api.nvim_buf_get_lines, buf, r, r + 1, false)
    if ok and #fetched > 0 then current_line = fetched[1] end
    
    local chars = vim.fn.split(current_line, "\\zs")
    while #chars < col do table.insert(chars, " ") end
    
    local box_chars = vim.fn.split(box_str, "\\zs")
    for b_i, char in ipairs(box_chars) do chars[col + b_i] = char end
    
    local new_line = table.concat(chars, "")
    api.nvim_buf_set_lines(buf, r, r + 1, false, { new_line })

    local prefix_str = table.concat(chars, "", 1, col)
    local byte_col = #prefix_str
    api.nvim_buf_set_extmark(buf, ns, r, byte_col, {
      end_col = byte_col + #box_str,
      hl_group = hl,
    })
  end
end

-- =====================
-- MAIN
-- =====================
function M.show()
  local buf = api.nvim_create_buf(false, true)
  api.nvim_set_current_buf(buf)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].modifiable = true
  
  vim.opt_local.cursorline = false
  vim.opt_local.cursorcolumn = false
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false

  local ns = api.nvim_create_namespace("SarVimLanding")
  local ui = api.nvim_list_uis()[1]
  local win_h, win_w = ui.height, ui.width

  -- Clear canvas
  local canvas = {}
  for _ = 1, win_h do canvas[#canvas + 1] = "" end
  api.nvim_buf_set_lines(buf, 0, -1, false, canvas)

  -- =====================
  -- LOGO
  -- =====================
  local logo = [[

    ███████╗  █████╗  ██████╗  ██╗   ██╗  ██╗  ███╗   ███╗
    ██╔════╝ ██╔══██╗ ██╔══██╗ ██║   ██║  ██║  ████╗ ████║
    ███████╗ ███████║ ██████╔╝ ██║   ██║  ██║  ██╔████╔██║
    ╚════██║ ██╔══██║ ██╔══██╗ ╚██╗ ██╔╝  ██║  ██║╚██╔╝██║
    ███████║ ██║  ██║ ██║  ██║  ╚████╔╝   ██║  ██║ ╚═╝ ██║
    ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝   ╚═══╝    ╚═╝  ╚═╝     ╚═╝

  ]]
  local logo_lines = vim.split(logo, "\n", { trimempty = true })
  local logo_h = #logo_lines
  local logo_row = math.max(math.floor(win_h / 2) - math.floor(logo_h / 2), 3)

  for i, line in ipairs(logo_lines) do
    line = line:gsub("^%s+", "")
    local pad = math.floor((win_w - api.nvim_strwidth(line)) / 2)
    local row = logo_row + i - 1
    if row >= 0 and row < win_h then
      api.nvim_buf_set_lines(buf, row, row + 1, false, { string.rep(" ", pad) .. line })
      api.nvim_buf_set_extmark(buf, ns, row, 0, { hl_group = "Identifier", hl_eol = true })
    end
  end

  -- =====================
  -- STATS (Fetched from log file)
  -- =====================
  local stats = read_stats_from_log()
  local total         = stats[1]
  local commits_today = stats[2]
  local streak        = stats[3]
  local raw_langs     = stats[4]
  
  -- Split comma-separated languages into table for icons
  local lang_data = vim.split(raw_langs, "%s+", { trimempty = true })
  
  local lang_str = ""
  local lang_colors = {} 

  for i = 1, math.min(#lang_data, 3) do
      local lang = lang_data[i]
      local icon, hl = get_lang_info(lang)
      
      local start_byte = #lang_str
      lang_str = lang_str .. icon
      local end_byte = #lang_str
      
      table.insert(lang_colors, { s = start_byte, e = end_byte, hl = hl })
      lang_str = lang_str .. " " 
  end
  if lang_str == "" then lang_str = " unknown" end

  local box_col = math.floor(win_w * 0.05)
  local box_text = { 
      " Commits Today : " .. commits_today, 
      " Current Streak: " .. streak .. " days", 
      " Total Commits : " .. total,
      " Primary Langs : " .. lang_str 
  }
  
  draw_box(buf, ns, logo_row, box_col, 40, box_text, "Comment") 
  local lang_row = logo_row + 4 

  local line_content = api.nvim_buf_get_lines(buf, lang_row, lang_row+1, false)[1]
  local lang_label = " Primary Langs : "
  local s_idx, e_idx = string.find(line_content, lang_label, 1, true)
  
  if e_idx then
      local icon_start_base = e_idx 
      for _, color_info in ipairs(lang_colors) do
          api.nvim_buf_add_highlight(buf, ns, color_info.hl, lang_row, icon_start_base + color_info.s, icon_start_base + color_info.e)
      end
  end

  -- =====================
  -- QUOTE & SOCIALS (Rest remains the same)
  -- =====================
  local quote = get_dev_quote()
  local q_pad = math.floor((win_w - api.nvim_strwidth(quote)) / 2)
  local q_row = win_h - 4
  api.nvim_buf_set_lines(buf, q_row, q_row + 1, false, { string.rep(" ", q_pad) .. quote })
  api.nvim_buf_set_extmark(buf, ns, q_row, 0, { hl_group = "Comment", hl_eol = true })

  local s_row = q_row - 3
  if s_row > 0 then
    local social_str = ""
    local total_visual_width = 0
    for i, item in ipairs(LINKS) do
        total_visual_width = total_visual_width + api.nvim_strwidth(item.icon)
        if i < #LINKS then total_visual_width = total_visual_width + api.nvim_strwidth(GAP_STR) end
    end
    
    local start_col = math.floor((win_w - total_visual_width) / 2)
    local social_str = ""
    for i, item in ipairs(LINKS) do
        social_str = social_str .. item.icon
        if i < #LINKS then social_str = social_str .. GAP_STR end
    end

    api.nvim_buf_set_lines(buf, s_row, s_row + 1, false, { string.rep(" ", start_col) .. social_str })
    local hl_cursor = start_col
    for i, item in ipairs(LINKS) do
        local icon_len = #item.icon
        api.nvim_buf_add_highlight(buf, ns, item.hl, s_row, hl_cursor, hl_cursor + icon_len)
        hl_cursor = hl_cursor + icon_len + #GAP_STR
    end
  end

  local function update_clock()
    if not api.nvim_buf_is_valid(buf) then return end
    api.nvim_buf_set_extmark(buf, ns, 0, 0, {
      id = 1, virt_text = {{ " " .. os.date("%B %d │ %H:%M:%S"), "PmenuSel" }}, virt_text_pos = "overlay",
    })
  end
  timer = uv.new_timer()
  timer:start(0, 1000, vim.schedule_wrap(update_clock))

  local function open_link()
    local cursor = api.nvim_win_get_cursor(0)
    local row, col = cursor[1] - 1, cursor[2]
    if row == s_row then
        local line = api.nvim_get_current_line()
        local text_start_idx = string.find(line, "%S")
        if not text_start_idx then return end Indent_bytes = text_start_idx - 1
        local rel_col = col - (text_start_idx - 1)
        local current_pos = 0
        for i, item in ipairs(LINKS) do
            local icon_len = #item.icon 
            if rel_col >= current_pos and rel_col < (current_pos + icon_len) then
                local browser = "google-chrome"
                if vim.fn.has("mac") == 1 then vim.fn.jobstart({ "open", item.url }, { detach = true })
                elseif vim.fn.has("unix") == 1 then vim.fn.jobstart({ browser, item.url }, { detach = true })
                else vim.fn.jobstart({ "start", item.url }, { detach = true }) end
                return
            end
            current_pos = current_pos + icon_len + #GAP_STR
        end
        return 
    end
    if timer then timer:stop(); timer:close() end
    vim.cmd("bd!")
    vim.cmd("Explore")
  end

  vim.keymap.set("n", "<CR>", open_link, { buffer = buf, silent = true })
  vim.keymap.set("n", "<LeftMouse>", function()
      local key = api.nvim_replace_termcodes("<LeftMouse>", true, false, true)
      api.nvim_feedkeys(key, "n", false)
      vim.schedule(open_link)
  end, { buffer = buf, silent = true })

  api.nvim_create_autocmd("BufWipeout", { buffer = buf, callback = function() if timer then timer:stop(); timer:close() end end })
  vim.bo[buf].modifiable = false
end

return M
