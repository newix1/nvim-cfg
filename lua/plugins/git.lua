---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo)
	return "https://github.com/" .. repo
end

local map = vim.keymap.set

---------------------------------------------------------------------
---------------------------- GitSigns -------------------------------
---------------------------------------------------------------------

vim.pack.add({
	{ src = gh("lewis6991/gitsigns.nvim") },
})

require("gitsigns").setup({
    signs = {
    -- Настройка знаков для изменённых файлов
    add          = { text = "│" },
    change       = { text = "│" },
    delete       = { text = "│" },
    topdelete    = { text = "│" },
    changedelete = { text = "│" },
    untracked    = { text = "│" },
  },
  signs_staged = {
    -- Знаки для проиндексированных (staged) изменений
    add          = { text = "│" },
    change       = { text = "│" },
    delete       = { text = "│" },
    topdelete    = { text = "│" },
    changedelete = { text = "│" },
    untracked    = { text = "│" },
  },
  signs_staged_enable = true,
	current_line_blame = true,
})

vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#98c379" })    -- Зелёный
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#e5c07b" }) -- Жёлтый
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#e06c75" }) -- Красный
vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = "#98c379" })   -- Зелёный для номеров строк
vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = "#e5c07b" })-- Жёлтый для номеров строк
vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = "#e06c75" })-- Красный для номеров строк

local gitsigns = require("gitsigns")

-- blame
map("n", "<Leader>gl", gitsigns.blame_line, { desc = "View Git blame" })
map("n", "<Leader>gL", function()
	gitsigns.blame_line({ full = true })
end, { desc = "View full Git blame" })

-- preview
map("n", "<Leader>gp", gitsigns.preview_hunk_inline, { desc = "Preview Git hunk" })

-- reset
map("n", "<Leader>gr", gitsigns.reset_hunk, { desc = "Reset Git hunk" })
map("v", "<Leader>gr", function()
	gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Reset Git hunk" })
map("n", "<Leader>gR", gitsigns.reset_buffer, { desc = "Reset Git buffer" })

-- stage
map("n", "<Leader>gs", gitsigns.stage_hunk, { desc = "Stage/Unstage Git hunk" })
map("v", "<Leader>gs", function()
	gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Stage Git hunk" })
map("n", "<Leader>gS", gitsigns.stage_buffer, { desc = "Stage Git buffer" })

-- diff
map("n", "<Leader>gd", gitsigns.diffthis, { desc = "View Git diff" })

-- navigation
map("n", "[G", function()
	gitsigns.nav_hunk("first")
end, { desc = "First Git hunk" })
map("n", "]G", function()
	gitsigns.nav_hunk("last")
end, { desc = "Last Git hunk" })
map("n", "]g", function()
	gitsigns.nav_hunk("next")
end, { desc = "Next Git hunk" })
map("n", "[g", function()
	gitsigns.nav_hunk("prev")
end, { desc = "Previous Git hunk" })

---------------------------------------------------------------------
----------------------------- NeoGit --------------------------------
---------------------------------------------------------------------

-- vim.pack.add({
-- 	{ src = gh("neogitorg/neogit") },
-- })
--
-- require("neogit").setup({})

-- ---------------------------------------------------------------------
-- ---------------------------- DiffView -------------------------------
-- ---------------------------------------------------------------------
--
-- vim.pack.add({
-- 	{ src = gh("sindrets/diffview.nvim") },
-- })
--
-- map('n', '<leader>gd', function()
--   local file = vim.api.nvim_buf_get_name(0)
--   if file == '' then return vim.notify('Сначала сохраните файл', vim.log.levels.WARN) end
--
--   local line = vim.api.nvim_win_get_cursor(0)[1]
--   local blame_cmd = string.format("git blame -L %d,%d --porcelain -- %s", line, line, vim.fn.shellescape(file))
--   local blame_out = vim.fn.system(blame_cmd)
--   if vim.v.shell_error ~= 0 then
--     return vim.notify('git blame failed: ' .. blame_out:gsub('\n', ' '), vim.log.levels.ERROR)
--   end
--
--   local full_hash = blame_out:match('^(%x+)')
--   if not full_hash then
--     return vim.notify('Строка ещё не закоммичена или файл не в git', vim.log.levels.INFO)
--   end
--
--   -- Получаем короткий хэш + заголовок коммита
--   local log_cmd = string.format('git log -1 --format="%%h %%s" %s', full_hash)
--   local log_out = vim.fn.system(log_cmd):gsub('\n$', '')
--
--   if log_out ~= '' then
--     vim.notify('🔍 ' .. log_out, vim.log.levels.INFO)
--     local short_hash = log_out:match('^([^%s]+)')
--     vim.cmd('DiffviewOpen ' .. short_hash .. '^!')
--   else
--     -- Fallback для shallow-репозиториев или если git log не ответил
--     vim.notify('⚠️ Заголовок не получен, открываю по полному хэшу', vim.log.levels.WARN)
--     vim.cmd('DiffviewOpen ' .. full_hash .. '^!')
--   end
-- end, { desc = 'Line commit blame (Diffview)' })
--
-- map('n', '<leader>gf', '<cmd>DiffviewFileHistory %<CR>', { desc = 'File History (Diffview)' })
--
-- map('n', '<leader>gt', '<cmd>DiffviewOpen<CR>', { desc = 'Git Status (Diffview)' })

---------------------------------------------------------------------
---------------------------- CodeDiff -------------------------------
---------------------------------------------------------------------

vim.pack.add({
	{ src = gh("esmuellert/codediff.nvim") },
})

-- Базовая настройка (можно будет позже расширить)
require("codediff").setup({
  diff = {
    layout = "side-by-side", -- или "inline" по умолчанию
    filler_text = "╱",
  },
})

-- === Основные команды ===

map('n', '<leader>gd', function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then return vim.notify('Сначала сохраните файл', vim.log.levels.WARN) end

  local line = vim.api.nvim_win_get_cursor(0)[1]
  local blame_cmd = string.format("git blame -L %d,%d --porcelain -- %s", line, line, vim.fn.shellescape(file))
  local blame_out = vim.fn.system(blame_cmd)
  if vim.v.shell_error ~= 0 then
    return vim.notify('git blame failed: ' .. blame_out:gsub('\n', ' '), vim.log.levels.ERROR)
  end

  local full_hash = blame_out:match('^(%x+)')
  if not full_hash then
    return vim.notify('Строка ещё не закоммичена или файл не в git', vim.log.levels.INFO)
  end

  -- Получаем короткий хэш + заголовок коммита
  local log_cmd = string.format('git log -1 --format="%%h %%s" %s', full_hash)
  local log_out = vim.fn.system(log_cmd):gsub('\n$', '')

  if log_out ~= '' then
    vim.notify('🔍 ' .. log_out, vim.log.levels.INFO)
    local short_hash = log_out:match('^([^%s]+)')
    vim.cmd('CodeDiff ' .. short_hash .. '~1')
  else
    -- Fallback для shallow-репозиториев или если git log не ответил
    vim.notify('⚠️ Заголовок не получен, открываю по полному хэшу', vim.log.levels.WARN)
    vim.cmd('DiffviewOpen ' .. full_hash .. '~1')
  end
end, { desc = 'Line commit blame (CodeDiff)' })

-- Открыть Git статус (эксплорер)
map("n", "<Leader>gs", "<Cmd>CodeDiff<CR>", { desc = "Codediff: Git status" })

-- === История файла ===

-- История текущего файла
map("n", "<Leader>gf", "<Cmd>CodeDiff history %<CR>", { desc = "Codediff: file history" })

-- -- История с последними N коммитами (например, 30)
-- map("n", "<Leader>gF", "<Cmd>CodeDiff history HEAD~30<CR>", { desc = "Codediff: last 30 commits" })
--
-- -- === Сравнение с ревизиями ===
--
-- -- Сравнить текущий файл с HEAD
-- map("n", "<Leader>gH", "<Cmd>CodeDiff file HEAD<CR>", { desc = "Codediff: diff with HEAD" })
--
-- -- Сравнить текущий файл с предыдущим коммитом
-- map("n", "<Leader>gh", "<Cmd>CodeDiff file HEAD~1<CR>", { desc = "Codediff: diff with HEAD~1" })

-- Сравнить текущий файл с произвольным коммитом (запросит хэш)
map("n", "<Leader>gc", function()
  local hash = vim.fn.input("Commit hash: ")
  if hash ~= "" then
    vim.cmd("CodeDiff file " .. hash)
  end
end, { desc = "Codediff: diff with commit" })

---------------------------------------------------------------------
--------------------------- GitLineage ------------------------------
---------------------------------------------------------------------

vim.pack.add({
  gh("lionyxml/gitlineage.nvim"),
  gh("sindrets/diffview.nvim"),
})

-- Настройка
require("gitlineage").setup({
  split = "auto", -- вертикальный или горизонтальный сплит
  keymap = nil, -- отключаем встроенный маппинг, чтобы задать свои бинды

  keys = {
    close = "q",        -- закрыть
    next_commit = "]c", -- следующий коммит (как в gitsigns/diffview)
    prev_commit = "[c", -- предыдущий коммит
    yank_commit = "yc", -- скопировать хэш коммита
    open_diff = "<CR>", -- открыть полный diff через diffview
  },
})

---------------------------------------------------------------------
------------------------------ TIG ----------------------------------
---------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/iberianpig/tig-explorer.vim" },
})

vim.keymap.set('n', '<leader>gG', '<cmd>Tig<CR>', { desc = 'Open Tig' })
