local C = {}
C.color_adjust = function ()
	
	local hl = vim.api.nvim_get_hl(0, {name="Normal"})
	
	local hex = string.format("%06x", hl.bg)
	local r = tonumber(string.sub(hex, 1, 2), 16)
	local g = tonumber(string.sub(hex, 3, 4), 16)
	local b = tonumber(string.sub(hex, 5, 6), 16)

	local max_val = math.max(r, g, b)
	
	-- We decrease the val by 3 for now
	if r == max_val then r = math.max(0, r - 2) end
	if g == max_val then g = math.max(0, g - 2) end
	if b == max_val then b = math.max(0, b - 2) end
	
	return string.format("#%02x%02x%02x", r,g,b)
end

return C
