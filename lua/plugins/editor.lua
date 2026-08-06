---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo)
	return "https://github.com/" .. repo
end

local map = vim.keymap.set

---------------------------------------------------------------------
----------------------------- Snacks --------------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = gh("folke/snacks.nvim") },
})

-- Включаем snacks только для lazygit
require("snacks").setup({
  lazygit = {
    configure = true, -- Автоматически настраивает lazygit под Neovim
    config = {
      os = { editPreset = "nvim-remote" }, -- Редактирование в текущем Neovim
    },
    theme = {
      -- Настройка цветов под твою тему (опционально)
      selectedLineBgColor = { bg = "Visual" },
      unstagedChangesColor = { fg = "DiagnosticError" },
    },
    win = {
      style = "lazygit",
    },
  },
  indent = {
    -- Настройка линий отступов
    indent = {
      enabled = true,
      char = "│",                -- символ вертикальной линии
      only_current = false,      -- показывать во всех окнах
      only_scope = false,        -- показывать линии только для текущей области (scope)
      hl = "SnacksIndent",       -- цветовая группа (можно задать массив для "радужных" линий)
    },

    -- Настройка подсветки текущей области (scope)
    scope = {
      enabled = true,
      char = "│",                -- символ для границ области
      underline = false,         -- подчёркивать начало области
      only_current = false,      -- показывать во всех окнах
      hl = "SnacksIndentScope",  -- цветовая группа
      priority = 200,
    },

    -- Анимация для появления области (работает в Neovim >= 0.10)
    animate = {
      enabled = true,
      style = "out",             -- "out", "up", "down", "up_down"
      easing = "linear",
      duration = {
        step = 20,               -- миллисекунд на шаг
        total = 500,             -- максимальная длительность анимации
      },
    },

    -- Фильтр для буферов (отключаем в терминалах и т.д.)
    filter = function(buf, win)
      return vim.g.snacks_indent ~= false
        and vim.b[buf].snacks_indent ~= false
        and vim.bo[buf].buftype == ""
    end,
  },
  words = {
    enabled = false,
    debounce = 200,      -- задержка перед обновлением (мс)
    notify_jump = false, -- не показывать уведомления при прыжке
    notify_end = true,   -- показывать уведомление при достижении конца
    foldopen = true,     -- раскрывать фолды при прыжке
    jumplist = true,     -- сохранять позицию в jumplist
    modes = { "n", "i", "c" }, -- режимы, в которых работает
    filter = function(buf)
      return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
    end,
  },
  scroll = {
    enabled = true,
    animate = {
      duration = { step = 10, total = 200 }, -- шаг и общая длительность
      easing = "linear",
    },
    -- ускоренная анимация при повторном скролле
    animate_repeat = {
      delay = 100,
      duration = { step = 5, total = 50 },
      easing = "linear",
    },
    filter = function(buf)
      -- Отключаем для терминалов и буферов с buftype "nowrite"
      if vim.bo[buf].buftype == "terminal" or vim.bo[buf].buftype == "nowrite" then
        return false
      end
      return vim.g.snacks_scroll ~= false
        and vim.b[buf].snacks_scroll ~= false
    end,
  },
  zen = {
    -- Отключаем затемнение (dim)
    toggles = {
      dim = false,   -- <-- выключаем затемнение кода
      git_signs = false,
      diagnostics = false,
      inlay_hints = false,
    },
    center = true,   -- центрируем окно
    show = {
      statusline = false,
      tabline = false,
    },
    win = {
      style = "zen",
      -- Настройки фона за окном
      backdrop = {
        transparent = false, -- делаем фон непрозрачным (чёрным)
        blend = 0,           -- без смешивания
      },
    },
  },
  statuscolumn = {
    enabled = true,
    -- Компоненты слева (более высокий приоритет — ближе к тексту)
    left = {
      "mark",   -- Знаки (диагностика, например, E, W)
      "sign",   -- Git-знаки (из gitsigns)
    },
    -- Компоненты справа (более высокий приоритет — ближе к тексту)
    right = {
      "fold",   -- Иконки фолдов
      "git",    -- Git-знаки
    },
    -- Настройка фолдов
    folds = {
      open = false,     -- не показывать иконки открытых фолдов
      git_hl = false,   -- не использовать цвета Git для фолдов
    },
    -- Паттерны для определения Git-знаков
    git = {
      patterns = { "GitSign", "MiniDiffSign" },
    },
    refresh = 50, -- обновление не чаще 50 мс
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeDiffOpen",
  callback = function()
    require("snacks").scroll.disable()
  end,
})

-- Включаем snacks.scroll обратно при закрытии CodeDiff
vim.api.nvim_create_autocmd("User", {
  pattern = "CodeDiffClose",
  callback = function()
    require("snacks").scroll.enable()
  end,
})

-- Бинд для открытия lazygit через snacks
vim.keymap.set("n", "<Leader>gg", function()
  require("snacks").lazygit.open()
end, { desc = "Open lazygit" })

-- Zen-режим
map("n", "<leader>z", function()
  Snacks.zen()
end, { desc = "Toggle Zen Mode" })

-- Zoom (увеличить текущее окно на весь экран)
map("n", "<leader>Z", function()
  Snacks.zen.zoom()
end, { desc = "Toggle Zoom" })

---------------------------------------------------------------------
--------------------------- LuaSnip ---------------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
})

-- Загружаем VS Code-сниппеты из friendly-snippets
require("luasnip.loaders.from_vscode").load()

-- Если нужно автоматическое расширение сниппетов без Tab
-- require("luasnip").config.setup({
--   enable_autosnippets = true,
-- })

-- -- Бинды для навигации по табстопам (если blink.cmp не справляется)
-- local ls = require("luasnip")
--
-- vim.keymap.set({"i", "s"}, "<Tab>", function()
--   if ls.expand_or_jumpable() then
--     ls.expand_or_jump()
--   end
-- end, { silent = true })
--
-- vim.keymap.set({"i", "s"}, "<S-Tab>", function()
--   if ls.jumpable(-1) then
--     ls.jump(-1)
--   end
-- end, { silent = true })

---------------------------------------------------------------------
--------------------------- blink.cmp -------------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = gh("saghen/blink.cmp"), version = 'v1.10.2' },
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
  return { text = " ", highlight = ctx.kind_hl }
end

require("luasnip.loaders.from_vscode").load()

require("luasnip").config.setup({
  enable_autosnippets = true,
})

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
map("n", "<Leader>xd", "<Cmd>Trouble close<CR>",
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

-- ---------------------------------------------------------------------
-- ----------------------- mini.indentscope ----------------------------
-- ---------------------------------------------------------------------
--
-- -- 1. Добавляем плагин
-- vim.pack.add({
--   { src = "https://github.com/nvim-mini/mini.indentscope" },
-- })
--
-- -- 2. Настройка
-- require("mini.indentscope").setup({
--   -- Настройка отрисовки
--   draw = {
--     -- Задержка перед отображением (в мс)
--     delay = 100,
--     -- Простая анимация без лишних эффектов
--     animation = require("mini.indentscope").gen_animation.none(),
--     -- Приоритет отображения (чтобы не перекрывалось другими элементами)
--     priority = 2,
--   },
--
--   -- Настройка внешнего вида
--   symbol = "│",  -- символ вертикальной линии
--
--   -- Опции вычисления области видимости
--   options = {
--     -- Тип границы: 'both' (сверху и снизу), 'top', 'bottom', 'none'
--     border = "both",
--     -- Учитывать столбец курсора для вычисления отступа
--     indent_at_cursor = true,
--     -- Максимальное число строк для поиска границ
--     n_lines = 10000,
--   },
--
--   -- Маппинги для работы с областью видимости
--   mappings = {
--     -- Текст-объекты (работают в визуальном режиме и с операторами)
--     object_scope = "ii",           -- внутренняя область
--     object_scope_with_border = "ai", -- область с границами
--     -- Перемещение к границам области
--     goto_top = "[i",   -- переход к верхней границе
--     goto_bottom = "]i", -- переход к нижней границе
--   },
-- })

-- ---------------------------------------------------------------------
-- ----------------------------- Arrow ---------------------------------
-- ---------------------------------------------------------------------
--
-- vim.pack.add({
--   { src = "https://github.com/otavioschwanck/arrow.nvim" },
-- })
--
-- -- Базовая настройка
-- require("arrow").setup({
--   -- Показывать иконки для файлов
--   show_icons = true,
--
--   -- Главная клавиша для вызова меню (одна клавиша!)
--   leader_key = ";", -- Рекомендуется одна клавиша, например, ";"
--
--   -- Разделять закладки по веткам Git (удобно, если переключаешься между задачами)
--   separate_by_branch = true,
--
--   -- Показывать полный путь только если есть одинаковые имена файлов
--   always_show_path = false,
--
--   -- Внешний вид окна
--   window = {
--     border = "rounded",
--     width = "auto",
--     height = "auto",
--   },
--
--   -- Клавиши для управления в меню
--   mappings = {
--     edit = "e",          -- редактировать файл
--     delete_mode = "d",   -- режим удаления
--     toggle = "s",        -- сохранить/убрать закладку
--     open_vertical = "v", -- открыть вертикально
--     open_horizontal = "-", -- открыть горизонтально
--     quit = "q",          -- закрыть меню
--     next_item = "]",
--     prev_item = "[",
--   },
-- })

vim.cmd("packadd nvim.undotree")

-- Команда уже есть, просто бинд для быстрого вызова
vim.keymap.set("n", "<Leader>ut", "<Cmd>Undotree<CR>", { desc = "Open undotree" })

---------------------------------core------------------------------------
-------------------------- multicursor.nvim --------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = "https://github.com/jake-stewart/multicursor.nvim", branch = "1.0" },
})

local mc = require("multicursor-nvim")
mc.setup()

local map = vim.keymap.set

-- === Добавление курсоров ===

-- Добавить курсор выше/ниже
map({"n", "x"}, "<C-Up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
map({"n", "x"}, "<C-Down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })

-- Добавить курсор на следующее/предыдущее совпадение слова/выделения
map({"n", "x"}, "<C-n>", function() mc.matchAddCursor(1) end, { desc = "Add cursor next match" })
map({"n", "x"}, "<C-p>", function() mc.matchAddCursor(-1) end, { desc = "Add cursor prev match" })

-- === Управление курсорами ===

-- Включить/выключить мультикурсоры
map({"n", "x"}, "<C-q>", mc.toggleCursor, { desc = "Toggle multi-cursor" })

-- Удалить текущий курсор (когда их несколько)
mc.addKeymapLayer(function(layerSet)
  layerSet({"n", "x"}, "<leader>cc", mc.deleteCursor, { desc = "Delete cursor" })
end)

-- Enable and clear cursors using escape.
mc.addKeymapLayer(function(layerSet)
layerSet("n", "<esc>", function()
    if not mc.cursorsEnabled() then
        mc.enableCursors()
    else
        mc.clearCursors()
    end
  end)
end)

-- === Навигация между курсорами ===

mc.addKeymapLayer(function(layerSet)
  layerSet({"n", "x"}, "<left>", mc.prevCursor, { desc = "Prev cursor" })
  layerSet({"n", "x"}, "<right>", mc.nextCursor, { desc = "Next cursor" })
end)

-- === Визуальные настройки ===

local hl = vim.api.nvim_set_hl
hl(0, "MultiCursorCursor", { reverse = true })
hl(0, "MultiCursorVisual", { link = "Visual" })
hl(0, "MultiCursorSign", { link = "SignColumn" })
hl(0, "MultiCursorMatchPreview", { link = "Search" })

-- === Дополнительные полезные действия ===

-- Добавить курсор на все совпадения в документе
map({"n", "x"}, "<leader>A", mc.matchAllAddCursors, { desc = "Add cursors for all matches" })

-- Восстановить последние курсоры (если случайно очистил)
map("n", "<leader>gv", mc.restoreCursors, { desc = "Restore cursors" })

-- ---------------------------------------------------------------------
-- --------------------------- mini.map --------------------------------
-- ---------------------------------------------------------------------
--
-- vim.pack.add({
--   { src = "https://github.com/nvim-mini/mini.map" },
-- })
--
-- require("mini.map").setup({
--   integrations = {
--     -- Подсветка диагностики (ошибки, предупреждения)
--     require("mini.map").gen_integration.diagnostic({
--       error = "DiagnosticFloatingError",
--       warn = "DiagnosticFloatingWarn",
--       info = "DiagnosticFloatingInfo",
--       hint = "DiagnosticFloatingHint",
--     }),
--     -- Подсветка Git-изменений через gitsigns
--     require("mini.map").gen_integration.gitsigns(),
--   },
--
--   symbols = {
--     -- Правильный вызов с разрешением 3x2 (стандартное)
--     encode = require("mini.map").gen_encode_symbols.block("3x2"),
--     scroll_line = "█",
--     scroll_view = "┃",
--   },
--
--   window = {
--     side = "right",
--     width = 10,
--     winblend = 25,
--     zindex = 10,
--     focusable = false,
--     show_integration_count = true,
--   },
-- })
--
-- -- Бинды
-- local map = vim.keymap.set
--
-- map("n", "<Leader>m", function()
--   require("mini.map").toggle()
-- end, { desc = "Toggle mini.map" })
--
-- map("n", "<Leader>ms", function()
--   require("mini.map").toggle_side()
-- end, { desc = "Toggle mini.map side" })
--
-- map("n", "<Leader>mf", function()
--   require("mini.map").toggle_focus()
-- end, { desc = "Toggle mini.map focus" })

-- ---------------------------------------------------------------------
-- --------------------------- xmap.nvim -------------------------------
-- ---------------------------------------------------------------------
--
-- vim.pack.add({
--   { src = "https://github.com/ivantokar/xmap.nvim" },
-- })
--
-- require("xmap").setup({
--   -- Размер и положение
--   width = 40,              -- Ширина окна
--   side = "right",          -- Справа или слева
--
--   -- Автооткрытие для поддерживаемых типов файлов
--   auto_open = false,       -- Не открывать автоматически, только по требованию
--
--   -- Поддерживаемые типы файлов
--   filetypes = {
--     "lua", "c", "cpp", "go", "rust", "python",
--     "javascript", "typescript", "typescriptreact",
--   },
--
--   -- Файлы, в которых не показывать
--   exclude_filetypes = {
--     "help", "terminal", "prompt", "qf",
--     "neo-tree", "NvimTree", "lazy",
--     "git", "oil",
--   },
--
--   -- Бинды
--   keymaps = {
--     toggle = "<leader>mm",   -- Включить/выключить
--     focus = "<leader>mf",    -- Сфокусироваться на мини-карте
--     jump = "<CR>",           -- Перейти к строке
--     close = "q",             -- Закрыть (внутри мини-карты)
--   },
--
--   -- Настройка Treesitter
--   treesitter = {
--     enable = true,
--     highlight_scopes = true,
--     languages = {
--       "lua", "c", "cpp", "go", "rust", "python",
--       "javascript", "typescript", "typescriptreact",
--     },
--   },
--
--   -- Отображение
--   render = {
--     relative_prefix = {
--       number_width = 4,
--       number_separator = " ",
--       separator = " ",
--       direction = {
--         up = "↑",
--         down = "↓",
--         current = "·",
--       },
--     },
--     max_line_length = 40,
--     throttle_ms = 100,
--   },
--
--   -- Навигация
--   navigation = {
--     show_relative_line = true,  -- Показывать расстояние до прыжка
--     auto_center = true,         -- Центрировать после прыжка
--     follow_cursor = true,       -- Следовать за курсором
--   },
-- })
--
-- -- Дополнительные бинды, если хочешь открывать/закрывать по-другому
-- local map = vim.keymap.set
--
-- map("n", "<leader>m", function()
--   require("xmap").toggle()
-- end, { desc = "Toggle minimap" })

---------------------------------------------------------------------
--------------------------- satellite.nvim --------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = "https://github.com/lewis6991/satellite.nvim" },
})

---------------------------------------------------------------------
---------------------------- nvim-navic -----------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = "https://github.com/SmiteshP/nvim-navic" },
})

local navic = require("nvim-navic")

navic.setup({
  -- Иконки (можно взять свои или оставить стандартные)
  icons = {
    File          = "󰈙 ",
    Module        = " ",
    Namespace     = "󰌗 ",
    Package       = " ",
    Class         = "󰌗 ",
    Method        = "󰆧 ",
    Property      = " ",
    Field         = " ",
    Constructor   = " ",
    Enum          = "󰕘",
    Interface     = "󰕘",
    Function      = "󰊕 ",
    Variable      = "󰆧 ",
    Constant      = "󰏿 ",
    String        = "󰀬 ",
    Number        = "󰎠 ",
    Boolean       = "◩ ",
    Array         = "󰅪 ",
    Object        = "󰅩 ",
    Key           = "󰌋 ",
    Null          = "󰟢 ",
    EnumMember    = " ",
    Struct        = "󰌗 ",
    Event         = " ",
    Operator      = "󰆕 ",
    TypeParameter = "󰊄 ",
    enabled       = true,
  },

  -- Подсветка иконок и текста
  highlight = false,

  -- Разделитель между элементами
  separator = "  ",

  -- Глубина контекста (0 = без ограничений)
  depth_limit = 0,

  -- Индикатор обрезания
  depth_limit_indicator = "..",

  -- Безопасный вывод для statusline/winbar
  safe_output = true,

  -- Автоматическое обновление на CursorMoved (отключаем для производительности)
  lazy_update_context = false,

  -- Клик для перехода (можно включить, если хочешь)
  click = false,

  -- Настройки LSP
  lsp = {
    auto_attach = true, -- Автоматически подключаться к LSP
    preference = { "vue_ls", "vtsls" },   -- Приоритет серверов (например, { "clangd", "pyright" })
  },
})

-- Добавляем navic в winbar
vim.opt.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

-- ---------------------------------------------------------------------
-- --------------------------- auto-save --------------------------------
-- ---------------------------------------------------------------------
--
-- vim.pack.add({
--   { src = "https://github.com/okuuva/auto-save.nvim" },
-- })
--
-- require("auto-save").setup({
--   enabled = true,
--
--   -- События, при которых сохранять
--   trigger_events = {
--     immediate_save = {
--       "FocusLost",    -- потеря фокуса окном
--       "InsertLeave",  -- выход из режима вставки
--       "BufLeave",     -- переключение буфера
--     },
--     defer_save = {},  -- отключаем отложенное сохранение
--   },
--
--   -- Что НЕ сохранять
--   condition = function(buf)
--     local ft = vim.bo[buf].filetype
--     local buftype = vim.bo[buf].buftype
--
--     -- Не сохранять терминалы, help, и некоторые специальные буферы
--     if ft == "help" or ft == "terminal" or buftype == "nofile" or buftype == "nowrite" then
--       return false
--     end
--     return true
--   end,
-- })
