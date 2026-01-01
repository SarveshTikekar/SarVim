local M = {}
local timer = nil

-- =====================
-- Quotes
-- =====================
M.get_dev_quotes = function()
  local script_path = debug.getinfo(1).source:sub(2)
  local dir = vim.fn.fnamemodify(script_path, ":h")
  local path = dir .. "/quotes.txt"

  if vim.fn.filereadable(path) == 0 then
    return { '"It\'s all talk until the code runs."' }
  end

  local quote_lines = vim.fn.systemlist(
    "grep '\"' " .. vim.fn.shellescape(path)
  )

  return (#quote_lines > 0)
    and quote_lines
    or { '"It\'s all talk until the code runs."' }
end

-- =====================
-- Dashboard
-- =====================
function M.show()
  local api = vim.api

  -- ===== LOGO =====
  local logo = [[

  ███████╗  █████╗  ██████╗  ██╗   ██╗  ██╗  ███╗   ███╗
  ██╔════╝ ██╔══██╗ ██╔══██╗ ██║   ██║  ██║  ████╗ ████║
  ███████╗ ███████║ ██████╔╝ ██║   ██║  ██║  ██╔████╔██║
  ╚════██║ ██╔══██║ ██╔══██╗ ╚██╗ ██╔╝  ██║  ██║╚██╔╝██║
  ███████║ ██║  ██║ ██║  ██║  ╚████╔╝   ██║  ██║ ╚═╝ ██║
  ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝   ╚═══╝    ╚═╝  ╚═╝     ╚═╝

]]

  -- ===== BUFFER SETUP =====
  local buf = api.nvim_create_buf(false, true)
  api.nvim_set_current_buf(buf)

  local ns = api.nvim_create_namespace("SarVimDash")
  local ui = api.nvim_list_uis()[1]
  local win_h, win_w = ui.height, ui.width

  -- Prepare empty canvas
  local canvas = {}
  for _ = 1, win_h do canvas[#canvas + 1] = "" end

  api.nvim_buf_set_lines(buf, 0, -1, false, canvas)

  -- ===== WRITE STATIC CONTENT ONCE =====
  vim.bo[buf].modifiable = true

  -- Draw Logo (centered)
  local logo_lines = vim.split(logo, "\n")
  local start_row = math.floor((win_h - #logo_lines) / 2) - 2

  for i, line in ipairs(logo_lines) do
    local width = api.nvim_strwidth(line)
    local pad = math.floor((win_w - width) / 2)
    local row = start_row + i

    if row >= 0 and row < win_h then
      api.nvim_buf_set_lines(
        buf,
        row,
        row + 1,
        false,
        { string.rep(" ", pad) .. line }
      )
      api.nvim_buf_add_highlight(buf, ns, "Identifier", row, 0, -1)
    end
  end

  -- Draw Quote (bottom centered)
  local quotes = M.get_dev_quotes()
  local quote = quotes[math.random(#quotes)]
  local q_row = win_h - 4
  local q_pad = math.floor((win_w - api.nvim_strwidth(quote)) / 2)

  api.nvim_buf_set_lines(
    buf,
    q_row,
    q_row + 1,
    false,
    { string.rep(" ", q_pad) .. quote }
  )
  api.nvim_buf_add_highlight(buf, ns, "Comment", q_row, 0, -1)

  vim.bo[buf].modifiable = false

  -- ===== CLOCK (EXTMARK ONLY) =====
  local function update_clock()
    if not api.nvim_buf_is_valid(buf) then
      if timer then timer:stop(); timer:close() end
      return
    end

    api.nvim_buf_set_extmark(buf, ns, 0, 0, {
      id = 1,
      virt_text = {
        { " " .. os.date("%B %d │ %H:%M:%S"), "PmenuSel" }
      },
      virt_text_pos = "overlay",
    })
  end

  timer = vim.loop.new_timer()
  timer:start(0, 1000, vim.schedule_wrap(update_clock))

  -- ===== CLEANUP =====
  api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    callback = function()
      if timer then timer:stop(); timer:close() end
    end,
  })

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].modifiable = false
end

return M

