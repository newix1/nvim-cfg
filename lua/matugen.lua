 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#111b2d',
    base01 = '#1c2c4a',
    base02 = '#192843',
    base03 = '#606774',
    base04 = '#afb1b6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#a866cc',
    base0A = '#6d5cd6',
    base0B = '#6794e4',
    base0C = '#cb96e9',
    base0D = '#93b3ec',
    base0E = '#a196e9',
    base0F = '#910017',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f2f3',          bg = '#111b2d' })
  hi('TelescopeBorder',         { fg = '#606774',             bg = '#111b2d' })
  hi('TelescopePromptNormal',   { fg = '#f2f2f3',          bg = '#111b2d' })
  hi('TelescopePromptBorder',   { fg = '#606774',             bg = '#111b2d' })
  hi('TelescopePromptPrefix',   { fg = '#6794e4',             bg = '#111b2d' })
  hi('TelescopePromptCounter',  { fg = '#afb1b6',  bg = '#111b2d' })
  hi('TelescopePromptTitle',    { fg = '#111b2d',             bg = '#6794e4' })
  hi('TelescopePreviewTitle',   { fg = '#111b2d',             bg = '#6d5cd6' })
  hi('TelescopeResultsTitle',   { fg = '#111b2d',             bg = '#a866cc' })
  hi('TelescopeSelection',      { fg = '#f2f2f3',          bg = '#192843' })
  hi('TelescopeSelectionCaret', { fg = '#6794e4',             bg = '#192843' })
  hi('TelescopeMatching',       { fg = '#6794e4',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
