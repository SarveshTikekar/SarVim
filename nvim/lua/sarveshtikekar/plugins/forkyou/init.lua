-- For ForkYou integration

local env = require("sarveshtikekar.env")

return {
  "forkyoudev/forkyou.nvim",
  config = function()
    require("forkyou").setup({
      api_token = env.FORKYOU_API_KEY,
    })
  end,
}
