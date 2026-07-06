vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-lualine/lualine.nvim'
})

vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

vim.pack.add({
  { src = "https://github.com/neogitorg/neogit" },
})

vim.pack.add({
  { src = "https://github.com/sindrets/diffview.nvim" },
})

vim.pack.add({
  { src = "https://github.com/esmuellert/codediff.nvim"},
})

vim.pack.add({
  { src = "https://github.com/lionyxml/gitlineage.nvim"},
})

require("gitlineage").setup ()

require("neogit").setup ()

require('gitsigns').setup {
  current_line_blame = true,
}

vim.pack.add({
  { src = "https://github.com/ibhagwan/fzf-lua" },
})

require('fzf-lua').setup({})

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

vim.pack.add({ 'https://github.com/saghen/blink.lib', 'https://github.com/saghen/blink.cmp' })
local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup()

vim.pack.add({
  { src = "https://github.com/stevearc/conform.nvim" },
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
    go = { "gofmt" },
  },
})

