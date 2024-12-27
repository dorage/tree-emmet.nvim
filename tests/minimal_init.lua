local test_utils = require("tests.utils")

test_utils.add_plugin({
  url = "https://github.com/nvim-treesitter/nvim-treesitter.git",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
      },
      sync_install = true,
    })
  end,
})
test_utils.add_plugin({
  url = "https://github.com/nvim-lua/plenary.nvim",
})

vim.opt.rtp:append(".")
vim.cmd("runtime plugin/plenary.vim")
require("plenary.busted")
