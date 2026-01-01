local C = {}

C.color_adjust = function(val)

  val = tonumber(val) or 2
  if val < 0 then val = 2 end

  local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  if not hl.bg then
    return "NONE"
  end

  local hex = string.format("%06x", hl.bg)
  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)

  local max_val = math.max(r, g, b)
  local adjusted = false

  -- Darken ONLY the first dominant channel (R → G → B)
  if r == max_val and not adjusted then
    r = math.max(0, r - val)
    adjusted = true
  end

  if g == max_val and not adjusted then
    g = math.max(0, g - val)
    adjusted = true
  end

  if b == max_val and not adjusted then
    b = math.max(0, b - val)
    adjusted = true
  end

  return string.format("#%02x%02x%02x", r, g, b)
end

return C
