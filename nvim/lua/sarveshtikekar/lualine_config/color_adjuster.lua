local C = {}

-- Blur-aware color adjuster
-- Always return NONE so compositor blur shows through the statusline.
-- No need to read Normal.bg — with blur active, transparent is always correct.
C.color_adjust = function()
  return "NONE"
end

return C
