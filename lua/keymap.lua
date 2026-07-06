local map = vim.keymap.set

local fzf = require("fzf-lua")

map("n", "<leader><leader>", fzf.files)
map("n", "<leader>/", fzf.live_grep)

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

vim.keymap.set('n', '<leader>gd', function()
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
    vim.cmd('DiffviewOpen ' .. short_hash .. '^!')
  else
    -- Fallback для shallow-репозиториев или если git log не ответил
    vim.notify('⚠️ Заголовок не получен, открываю по полному хэшу', vim.log.levels.WARN)
    vim.cmd('DiffviewOpen ' .. full_hash .. '^!')
  end
end, { desc = 'Diffview: коммит строки (с заголовком)' })

vim.keymap.set('n', '<leader>gf', '<cmd>DiffviewFileHistory %<CR>', { desc = 'История текущего файла' })

vim.keymap.set('n', '<leader>gs', '<cmd>DiffviewOpen<CR>', { desc = 'Staged/Unstaged diff' })

vim.keymap.set('n', '<leader>gg', '<cmd>Tig<CR>', { desc = 'Open Tig' })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

map('n', '<leader>rn', function()
    vim.lsp.buf.rename()
end, { silent = true, desc = 'LSP: Rename symbol' })

map('n', '<leader>gr', function()
  vim.lsp.buf.references({ includeDeclaration = false })
end, { silent = true, desc = 'LSP: Найти все вызовы' })

-- diagnostic
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
