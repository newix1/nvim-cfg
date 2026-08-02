require("config")
require("keymap")
require("plugins/init")
require("lsp")

vim.pack.add { { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } }

vim.cmd.colorscheme "catppuccin-macchiato"
