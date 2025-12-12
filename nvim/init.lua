-- Main Entry to our Ricing setup

require("sarveshtikekar.landing_page.land_page").show()
require("sarveshtikekar.remaps")


-- Entry point for lazy plugins

vim.opt.rtp:prepend("/home/sarvesh/.local/share/nvim/lazy/lazy.nvim")

require("lazy").setup("sarveshtikekar.plugins", {

	ui = {open = "none"}
})
