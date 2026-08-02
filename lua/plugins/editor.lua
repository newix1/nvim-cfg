---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo)
	return "https://github.com/" .. repo
end

local map = vim.keymap.set

-- ---------------------------------------------------------------------
-- ----------------------------- Snacks --------------------------------
-- ---------------------------------------------------------------------
--
-- vim.pack.add({
-- 	{ src = gh("folke/snacks.nvim") },
-- })

---------------------------------------------------------------------
--------------------------- blink.cmp -------------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = gh("saghen/blink.cmp") },
  { src = gh("saghen/blink.lib") },
  { src = gh("L3MON4D3/LuaSnip") }, -- для сниппетов
})

-- Функция для проверки, есть ли слова перед курсором
local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Функция для иконок
local function get_kind_icon(ctx)
  -- Иконки для LSP-кидов (используем nvim-web-devicons)
  local icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
  }

  if ctx.item.source_name == "LSP" then
    local kind = ctx.kind or ""
    return { text = (icons[kind] or "󰠱") .. " ", highlight = ctx.kind_hl }
  end
  return { text = "󰈙 ", highlight = ctx.kind_hl }
end

-- Настройка blink.cmp
require("blink.cmp").setup({
  snippets = {
    preset = "luasnip",
  },
  keymap = {
    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<C-N>"] = { "select_next", "show" },
    ["<C-P>"] = { "select_prev", "show" },
    ["<C-J>"] = { "select_next", "fallback" },
    ["<C-K>"] = { "select_prev", "fallback" },
    ["<C-U>"] = { "scroll_documentation_up", "fallback" },
    ["<C-D>"] = { "scroll_documentation_down", "fallback" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = {
      "select_next",
      "snippet_forward",
      function(cmp)
        if has_words_before() or vim.api.nvim_get_mode().mode == "c" then
          return cmp.show()
        end
      end,
      "fallback",
    },
    ["<S-Tab>"] = {
      "select_prev",
      "snippet_backward",
      function(cmp)
        if vim.api.nvim_get_mode().mode == "c" then
          return cmp.show()
        end
      end,
      "fallback",
    },
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
    menu = {
      auto_show = function(ctx)
        return ctx.mode ~= "cmdline"
      end,
      border = "rounded",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      draw = {
        treesitter = { "lsp" },
        components = {
          kind_icon = {
            text = function(ctx)
              return get_kind_icon(ctx).text
            end,
            highlight = function(ctx)
              return get_kind_icon(ctx).highlight
            end,
          },
        },
      },
    },
    accept = {
      auto_brackets = { enabled = true },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
      window = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      },
    },
  },

  signature = {
    window = {
      border = "rounded",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    },
  },
})

vim.pack.add({
  { src = "https://github.com/folke/trouble.nvim" },
})

require("trouble").setup({})

-- Диагностика
map("n", "<Leader>xx", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
  { desc = "Document Diagnostics (Trouble)" })

map("n", "<Leader>xX", "<Cmd>Trouble diagnostics toggle<CR>",
  { desc = "Workspace Diagnostics (Trouble)" })

-- Списки
map("n", "<Leader>xL", "<Cmd>Trouble loclist toggle<CR>",
  { desc = "Location List (Trouble)" })

map("n", "<Leader>xQ", "<Cmd>Trouble quickfix toggle<CR>",
  { desc = "Quickfix List (Trouble)" })

-- Символы (опционально)
map("n", "<Leader>xs", "<Cmd>Trouble symbols toggle focus=false<CR>",
  { desc = "Document Symbols (Trouble)" })

map("n", "<Leader>xS", "<Cmd>Trouble lsp toggle focus=false win.position=right<CR>",
  { desc = "Workspace Symbols (Trouble)" })

-- LSP
map("n", "<Leader>xr", "<Cmd>Trouble lsp_references toggle<CR>",
  { desc = "LSP References (Trouble)" })

map("n", "<Leader>xi", "<Cmd>Trouble lsp_implementations toggle<CR>",
  { desc = "LSP Implementations (Trouble)" })

-- Закрыть
map("n", "<Leader>x", "<Cmd>Trouble close<CR>",
  { desc = "Close Trouble" })

---------------------------------------------------------------------
--------------------------- nvim-autopairs ---------------------------
---------------------------------------------------------------------

-- 1. Добавляем плагин
vim.pack.add({
  { src = "https://github.com/windwp/nvim-autopairs" },
})

-- 2. Базовая настройка
require("nvim-autopairs").setup({
  -- Отключаем для некоторых файлов (например, в терминале или при поиске)
  disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input" },

  -- Не ставить пары в макросах
  disable_in_macro = true,

  -- Не ставить пары в replace-режиме
  disable_in_replace_mode = true,

  -- Разрешить движение вправо через пару
  enable_moveright = true,

  -- Добавлять скобки после кавычек
  enable_afterquote = true,

  -- Проверять, есть ли закрывающая скобка в строке (чтобы не дублировать)
  enable_check_bracket_line = true,

  -- Ставить скобки внутри кавычек
  enable_bracket_in_quote = true,

  -- Маппить <CR> для автодобавления переноса
  map_cr = true,

  -- Маппить <BS> для удаления пары
  map_bs = true,

  -- Не маппить <C-h> (обычно и так работает)
  map_c_h = false,

  -- Не маппить <C-w> (может конфликтовать)
  map_c_w = false,
})

-- Если ты используешь blink.cmp (а у тебя он есть), добавь интеграцию:
-- Это нужно, чтобы автопары работали при выборе элемента из автодополнения.
pcall(function()
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp = require("cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end)

---------------------------------------------------------------------
------------------------ vim-illuminate -----------------------------
---------------------------------------------------------------------

-- 1. Добавляем плагин
vim.pack.add({
  { src = "https://github.com/RRethy/vim-illuminate" },
})

-- 2. Настройка
require("illuminate").configure({
  -- Провайдеры: LSP, Treesitter, Regex (в порядке приоритета)
  providers = {
    "lsp",
    "treesitter",
    "regex",
  },

  -- Задержка перед подсветкой (мс)
  delay = 100,

  -- Не подсвечивать в этих типах файлов
  filetypes_denylist = {
    "dirbuf",
    "dirvish",
    "fugitive",
    "neo-tree",
    "TelescopePrompt",
  },

  -- Не подсвечивать в этих режимах
  modes_denylist = {},

  -- Подсвечивать слово под курсором
  under_cursor = true,

  -- Для больших файлов (> 10000 строк) отключаем
  large_file_cutoff = 10000,
  large_file_overrides = nil,

  -- Минимальное количество совпадений для подсветки
  min_count_to_highlight = 1,

  -- Регистронезависимый поиск для regex
  case_insensitive_regex = false,
})

-- 4. Бинды для навигации по подсвеченным словам
local map = vim.keymap.set

-- Переход к следующему совпадению
map("n", "<a-n>", function()
  require("illuminate").goto_next_reference()
end, { desc = "Next illuminated reference" })

-- Переход к предыдущему совпадению
map("n", "<a-p>", function()
  require("illuminate").goto_prev_reference()
end, { desc = "Previous illuminated reference" })

-- Бинды для управления подсветкой
map("n", "<Leader>up", "<Cmd>IlluminatePause<CR>", { desc = "Pause illumination" })
map("n", "<Leader>ur", "<Cmd>IlluminateResume<CR>", { desc = "Resume illumination" })
map("n", "<Leader>ut", "<Cmd>IlluminateToggle<CR>", { desc = "Toggle illumination" })

---------------------------------------------------------------------
----------------------- mini.indentscope ----------------------------
---------------------------------------------------------------------

-- 1. Добавляем плагин
vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.indentscope" },
})

-- 2. Настройка
require("mini.indentscope").setup({
  -- Настройка отрисовки
  draw = {
    -- Задержка перед отображением (в мс)
    delay = 100,
    -- Простая анимация без лишних эффектов
    animation = require("mini.indentscope").gen_animation.none(),
    -- Приоритет отображения (чтобы не перекрывалось другими элементами)
    priority = 2,
  },

  -- Настройка внешнего вида
  symbol = "│",  -- символ вертикальной линии

  -- Опции вычисления области видимости
  options = {
    -- Тип границы: 'both' (сверху и снизу), 'top', 'bottom', 'none'
    border = "both",
    -- Учитывать столбец курсора для вычисления отступа
    indent_at_cursor = true,
    -- Максимальное число строк для поиска границ
    n_lines = 10000,
  },

  -- Маппинги для работы с областью видимости
  mappings = {
    -- Текст-объекты (работают в визуальном режиме и с операторами)
    object_scope = "ii",           -- внутренняя область
    object_scope_with_border = "ai", -- область с границами
    -- Перемещение к границам области
    goto_top = "[i",   -- переход к верхней границе
    goto_bottom = "]i", -- переход к нижней границе
  },
})

---------------------------------------------------------------------
----------------------------- Arrow ---------------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = "https://github.com/otavioschwanck/arrow.nvim" },
})

-- Базовая настройка
require("arrow").setup({
  -- Показывать иконки для файлов
  show_icons = true,

  -- Главная клавиша для вызова меню (одна клавиша!)
  leader_key = "m", -- Рекомендуется одна клавиша, например, ";"

  -- Разделять закладки по веткам Git (удобно, если переключаешься между задачами)
  separate_by_branch = true,

  -- Показывать полный путь только если есть одинаковые имена файлов
  always_show_path = false,

  -- Внешний вид окна
  window = {
    border = "rounded",
    width = "auto",
    height = "auto",
  },

  -- Клавиши для управления в меню
  mappings = {
    edit = "e",          -- редактировать файл
    delete_mode = "d",   -- режим удаления
    toggle = "s",        -- сохранить/убрать закладку
    open_vertical = "v", -- открыть вертикально
    open_horizontal = "-", -- открыть горизонтально
    quit = "q",          -- закрыть меню
    next_item = "]",
    prev_item = "[",
  },
})

-- Бинды для быстрого переключения между закладками
local map = vim.keymap.set
local arrow = require("arrow")

-- Лидер-клавиша (по умолчанию ";") открывает меню
-- Это настраивается в `leader_key`, так что отдельно биндить не нужно

-- Дополнительные бинды для переключения предыдущей/следующей закладки
map("n", "H", function() arrow.persist.previous() end, { desc = "Arrow: previous file" })
map("n", "L", function() arrow.persist.next() end, { desc = "Arrow: next file" })
