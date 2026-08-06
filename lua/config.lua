-- This file is automatically loaded after init.lua

require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = {
      [''] = 'msg',            -- Сообщения по умолчанию
      empty = 'cmd',           -- Пустые сообщения
      bufwrite = 'msg',        -- <--- Запись файла → в msg (не в cmd)
      confirm = 'cmd',         -- Подтверждения
      emsg = 'pager',          -- Ошибки → pager
      echo = 'msg',            -- Обычные сообщения → msg
      echomsg = 'msg',         -- Сообщения → msg
      echoerr = 'pager',       -- Ошибки → pager
      completion = 'cmd',      -- Дополнение → cmd
      list_cmd = 'pager',      -- Списки → pager
      lua_error = 'pager',     -- Ошибки Lua → pager
      lua_print = 'msg',       -- print() → msg
      progress = 'pager',      -- Прогресс → pager
      rpc_error = 'pager',     -- Ошибки RPC → pager
      quickfix = 'msg',        -- Quickfix → msg
      search_cmd = 'cmd',      -- Поиск → cmd
      search_count = 'cmd',    -- Счётчик поиска → cmd
      shell_cmd = 'pager',     -- Команды шелла → pager
      shell_err = 'pager',     -- Ошибки шелла → pager
      shell_out = 'pager',     -- Вывод шелла → pager
      shell_ret = 'msg',       -- Возврат шелла → msg
      undo = 'msg',            -- Отмена → msg
      verbose = 'pager',       -- Вербоз → pager
      wildlist = 'cmd',        -- Список wildcard → cmd
      wmsg = 'msg',            -- Сообщения → msg
      typed_cmd = 'msg',       -- Введённые команды → cmd
    },
    cmd = {
      height = 0.5,            -- Для поиска и команд
    },
    dialog = {
      height = 0.5,            -- Для диалогов
    },
    msg = {
      height = 0.3,            -- Окошко для сообщений (не перекрывает lualine)
      timeout = 3000,          -- Исчезает через 3 секунды
    },
    pager = {
      height = 0.5,            -- Для длинных сообщений
    },
  },
})

-- отключить отображение табов и других нев. символов для go
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.list = false
  end,
})

-- -- winbar показывает текущую функцию/класс через LSP (асинхронно)
-- vim.opt.winbar = "%{%v:lua.WinBar()%}"
--
-- -- Кеш для winbar
-- local winbar_cache = {}
--
-- function WinBar()
--   local bufnr = vim.api.nvim_get_current_buf()
--   local row = vim.api.nvim_win_get_cursor(0)[1] - 1
--
--   -- Проверяем кеш (если есть и совпадает строка)
--   if winbar_cache[bufnr] and winbar_cache[bufnr].row == row then
--     return winbar_cache[bufnr].text
--   end
--
--   -- Проверяем, есть ли LSP-клиент
--   local clients = vim.lsp.get_clients({ bufnr = bufnr })
--   if #clients == 0 then
--     winbar_cache[bufnr] = { row = row, text = "" }
--     return ""
--   end
--
--   -- Асинхронный запрос к LSP
--   local params = { textDocument = { uri = vim.uri_from_bufnr(bufnr) } }
--   vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, function(err, result)
--     if err or not result then
--       winbar_cache[bufnr] = { row = row, text = "" }
--       vim.cmd("redrawstatus")
--       return
--     end
--
--     local symbols = result
--     if not symbols or #symbols == 0 then
--       winbar_cache[bufnr] = { row = row, text = "" }
--       vim.cmd("redrawstatus")
--       return
--     end
--
--     -- Рекурсивно собираем все символы
--     local function flatten_symbols(sym_list, acc)
--       acc = acc or {}
--       for _, sym in ipairs(sym_list) do
--         table.insert(acc, sym)
--         if sym.children then
--           flatten_symbols(sym.children, acc)
--         end
--       end
--       return acc
--     end
--
--     local flat_symbols = flatten_symbols(symbols)
--
--     -- Ищем символ, содержащий текущую строку
--     local current_symbol = nil
--     for _, sym in ipairs(flat_symbols) do
--       local range = sym.range or sym.selectionRange
--       if range and range.start.line <= row and range["end"].line >= row then
--         current_symbol = sym
--         break
--       end
--     end
--
--     if current_symbol then
--       winbar_cache[bufnr] = { row = row, text = "  " .. current_symbol.name }
--     else
--       winbar_cache[bufnr] = { row = row, text = "" }
--     end
--
--     -- Обновляем статусную строку, чтобы отобразить winbar
--     vim.cmd("redrawstatus")
--   end)
--
--   -- Пока LSP не ответил, показываем пустую строку
--   return ""
-- end

vim.opt.completeopt:append("popup")
local progress = vim.ui.progress_status()

local g = vim.g

-- Возвращать курсор на последнюю позицию при открытии файла
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

---------------------------------------------------------------------
------------------- Highlight Trailing Whitespace -------------------
---------------------------------------------------------------------

-- 1. Создаём группу подсветки (красный фон)
vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#ff0000" })

-- 2. Функция для включения подсветки
local function enable_trailing_whitespace_highlight()
  local filetype = vim.bo.filetype
  local code_filetypes = {
    "lua", "python", "c", "cpp", "rust", "go", "javascript",
    "typescript", "java", "ruby", "php", "sh", "bash", "zsh",
    "vim", "toml", "yaml", "json", "html", "css", "scss",
  }

  -- Удаляем старый матч, если был
  pcall(vim.cmd, "match none")

  -- Включаем для кода
  if vim.tbl_contains(code_filetypes, filetype) then
    vim.cmd("match TrailingWhitespace /\\s\\+$/")
  end
end

-- 3. Автоматически применяем при открытии файлов и при изменении типа
vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost", "FileType" }, {
  callback = enable_trailing_whitespace_highlight,
})

-- 4. Для пустых буферов без типа — тоже выключаем
vim.api.nvim_create_autocmd("BufNewFile", {
  callback = function()
    pcall(vim.cmd, "match none")
  end,
})

-- ---------------------------------------------------------------------
-- ------------------------- Auto-save ---------------------------------
-- ---------------------------------------------------------------------
--
-- -- Сохранять при потере фокуса (переключился в браузер/терминал)
-- vim.api.nvim_create_autocmd("FocusLost", {
--   callback = function()
--     vim.cmd("silent! wall")
--   end,
-- })
--
-- -- Сохранять при выходе из режима вставки (как в VS Code)
-- vim.api.nvim_create_autocmd("InsertLeave", {
--   callback = function()
--     vim.cmd("silent! wall")
--   end,
-- })
--
-- -- Сохранять при переключении буферов
-- vim.api.nvim_create_autocmd("BufLeave", {
--   callback = function()
--     vim.cmd("silent! wall")
--   end,
-- })
--
-- vim.opt.autoread = true
-- vim.api.nvim_create_autocmd("FocusGained", {
--   callback = function()
--     vim.cmd("checktime")
--   end,
-- })
--
-- -- Сохранять файл после undo
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "UndoRedo",
--   callback = function()
--     vim.cmd("silent! wall") -- сохранить все изменённые буферы
--   end,
-- })

-- g.clipboard = {
-- 	name = "OSC 52",
-- 	copy = {
-- 		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
-- 		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
-- 	},
-- 	paste = {
-- 		["+"] = require("vim.ui.clipboard.osc52").paste("+"),
-- 		["*"] = require("vim.ui.clipboard.osc52").paste("*"),
-- 	},
-- }

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = true

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
vim.g.ai_cmp = true

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- Optionally setup the terminal to use
-- This sets `vim.o.shell` and does some additional configuration for:
-- * pwsh
-- * powershell
-- LazyVim.terminal.setup("pwsh")

-- Set LSP servers to be ignored when used with `util.root.detectors.lsp`
-- for detecting the LSP root
vim.g.root_lsp_ignore = { "copilot" }

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Show the current document symbols location from Trouble in lualine
-- You can disable this for a buffer by setting `vim.b.trouble_lualine = false`
vim.g.trouble_lualine = true

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
-- ----------------------------------------------------------------------------------------------------------------
-- opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard (OSC 52 not works)
-- ----------------------------------------------------------------------------------------------------------------
-- opt.clipboard = "unnamedplus" -- Sync with system clipboard (OSC 52)
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showmode = false
opt.sidescrolloff = 8 -- Columns of context
opt.scrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
vim.o.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winborder = 'rounded'
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Пользовательская команда :Git
vim.api.nvim_create_user_command("Git", function(opts)
  local args = opts.args
  if args == "" then
    vim.notify("Usage: :Git <command>", vim.log.levels.INFO)
    return
  end

  -- Выполняем git команду
  local cmd = "git " .. args
  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Git error: " .. output, vim.log.levels.ERROR)
    return
  end

  -- Если вывод пустой, просто уведомление
  if output == "" then
    vim.notify("Git command executed successfully", vim.log.levels.INFO)
    return
  end

  -- Открываем вывод в новом буфере (без записи на диск)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))

  -- Настройки окна
  local opts_win = {
    relative = "editor",
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.6),
    row = math.floor((vim.o.lines - math.floor(vim.o.lines * 0.6)) / 2),
    col = math.floor((vim.o.columns - math.floor(vim.o.columns * 0.8)) / 2),
    style = "minimal",
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, opts_win)
  vim.bo[buf].filetype = "git"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"

  -- Бинд для закрытия окна (q)
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })

end, {
  nargs = "+",
  complete = function(arg_lead, cmd_line, cursor_pos)
    local commands = {
      "status", "log", "diff", "show", "cherry-pick", "rebase",
      "branch", "checkout", "merge", "pull", "push", "stash",
    }
    return vim.tbl_filter(function(cmd)
      return vim.startswith(cmd, arg_lead)
    end, commands)
  end,
})

vim.diagnostic.config{
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "",
        },
    },
}
