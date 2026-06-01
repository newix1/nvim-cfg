require("config")
require("plugins")
require("keymap")
require("lsp")

vim.cmd.colorscheme "catppuccin-macchiato"
vim.o.timeoutlen = 1000

require('lualine').setup()
