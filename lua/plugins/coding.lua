local map = vim.keymap.set

-- Шпаргалка по плагинам ZeroVim
local function plugins_cheatsheet()
  local lines = {
    "── ZeroVim: Плагины для кодинга ──",
    "",
    "── mini.ai (умные текстовые объекты) ──",
    "a( / i( – вокруг/внутри скобок ()",
    "a[ / i[ – вокруг/внутри скобок []",
    "a{ / i{ – вокруг/внутри скобок {}",
    "a' / i' – вокруг/внутри кавычек ''",
    "a\" / i\" – вокруг/внутри кавычек \"\"",
    "af / if – вокруг/внутри функции",
    "a? / i? – вокруг/внутри аргумента",
    "an / in – следующий объект (next)",
    "al / il – предыдущий объект (last)",
    "g[ / g] – перемещение к левому/правому краю",
    "",
    "── mini.surround (работа с окружениями) ──",
    "sa) – добавить окружение ()",
    "sd) – удалить окружение ()",
    "sr)( – заменить () на []",
    "sf) – найти окружение ) вперёд",
    "sF) – найти окружение ) назад",
    "sh) – подсветить окружение )",
    "",
    "── various-textobjs (доп. текстовые объекты) ──",
    "ii / ai – внутренний/внешний отступ",
    "iS / aS – сегмент слова (camel/snake/kebab-case)",
    "io / ao – любые скобки ()[]{} в одной строке",
    "iq / aq – любые кавычки '' \"\" `` в одной строке",
    "iv / av – значение ключ-значение",
    "ik / ak – ключ ключ-значение",
    "in / an – число",
    "i, / a, – аргумент, разделённый запятыми",
    "iF / aF – путь к файлу",
    "i# / a# – цвет (HEX/RGB/HSL/ANSI)",
    "iD / aD – текст в [[ ]]",
    "C – до следующей закрывающей скобки",
    "Q – до следующей кавычки",
    "R – строки вниз с таким же отступом",
    "r – остаток параграфа",
    "gG – весь буфер",
    "n – до конца строки",
    "_ – текущая строка (посимвольно)",
    "| – столбец вниз",
    "L – URL-ссылка",
    "! – диагностика nvim",
    "iz / az – закрытый фолд",
    "im / am – секция цепочки через . или :",
    "gw – все строки в окне",
    "gW – от текущей до последней строки в окне",
    "g; – последнее изменение",
    "iN / aN – ячейка ноутбука",
    ". – эмодзи или глиф",
    "",
    "── mini.move (перемещение) ──",
    "Alt+hjkl – переместить строку/блок",
    "",
    "── mini.splitjoin ──",
    "gS  – развернуть/свернуть блок (split/join)",
    "",
    "── iswap.nvim (обмен местами) ──",
    "Не имеет горячей клавиши.",
    "Работает через :ISwap команду",
    "",
    "── render-markdown.nvim ──",
    "Включается автоматически для .md файлов",
    "",
    "── project.nvim ──",
    "<leader>pp – переключиться между проектами",
    "",
    "── yanky.nvim (улучшенная работа с регистрами) ──",
    "y      – yank с сохранением позиции курсора",
    "p      – вставить после курсора (с поддержкой ring)",
    "P      – вставить перед курсором",
    "gp     – вставить после и оставить курсор после вставки",
    "gP     – вставить перед и оставить курсор после вставки",
    "Ctrl+n – следующий элемент в истории (после p/P)",
    "Ctrl+p – предыдущий элемент в истории (после p/P)",
    "]p     – вставить строку ниже с отступом",
    "[p     – вставить строку выше с отступом",
    "]P     – вставить строку ниже с отступом (альт.)",
    "[P     – вставить строку выше с отступом (альт.)",
    ">p     – вставить и увеличить отступ",
    "<p     – вставить и уменьшить отступ",
    ">P     – вставить перед и увеличить отступ",
    "<P     – вставить перед и уменьшить отступ",
    "=p     – вставить и переформатировать отступ",
    "=P     – вставить перед и переформатировать отступ",
    "iy     – текстовый объект для последней вставки (если включен)",
    "",
    "── zen-mode.nvim ──",
    "<leader>z – включить/выключить Zen Mode",
    "",
    "── undotree (встроенный) ──",
    "<leader>u – открыть дерево отмен",
    "",
    "── multicursor.nvim ──",
    "Ctrl+Up/Down       – добавить курсор выше/ниже",
    "Ctrl+n             – добавить курсор на следующее совпадение",
    "Ctrl+p             – добавить курсор на предыдущее совпадение",
    "Ctrl+q             – включить/выключить мультикурсоры",
    "<leader>cc         – удалить текущий курсор",
    "Esc                – очистить все курсоры (или включить, если отключены)",
    "← / →              – переключиться между курсорами",
    "<leader>A          – добавить курсоры на все совпадения в документе",
    "<leader>gv         – восстановить последние курсоры",
    "",
    "── dial.nvim (увеличение/уменьшение) ──",
    "Ctrl+a – увеличить число",
    "Ctrl+x – уменьшить число",
    "",
    "q – закрыть шпаргалку",
  }

  vim.cmd("new")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.buftype = "nofile"
  vim.bo.filetype = "help"
  vim.bo.bufhidden = "wipe"
  vim.api.nvim_buf_set_keymap(0, "n", "q", ":q<CR>", { noremap = true, silent = true })
  vim.cmd("resize 25")
end

vim.keymap.set("n", "<Leader>p?", plugins_cheatsheet, { desc = "Плагины ZeroVim: шпаргалка" })

-- vim.pack.add({ 'https://github.com/nvim-mini/mini.ai' })
--
-- require('mini.ai').setup()

-- ----------------------------------------------------------------------------------------
--
-- vim.pack.add({ 'https://github.com/nvim-mini/mini.surround' })
--
-- require('mini.surround').setup()

----------------------------------------------------------------------------------------

-- NOTE: This requires Neovim version 0.12 and greater!
vim.pack.add({ {
    src = "https://github.com/kylechui/nvim-surround",
    version = vim.version.range("4.x"), -- Use for stability; omit to use `main` branch for the latest features
} })

----------------------------------------------------------------------------------------

vim.pack.add({ 'https://github.com/gbprod/yanky.nvim' })

require("yanky").setup({})

----------------------------------------------------------------------------------------

vim.pack.add({ 'https://github.com/meanderingprogrammer/render-markdown.nvim' })

require("render-markdown").setup({})

----------------------------------------------------------------------------------------

vim.pack.add({ 'https://github.com/DrKJeff16/project.nvim' })

require("project").setup({
    fzf_lua = {
    -- Enables fzf-lua picker integration
    enabled = true,
  }
})

vim.keymap.set("n", "<leader>pp", "<Cmd>Project fzf-lua<CR>", { desc = "Open project" })

---------------------------------------------------------------------
---------------- nvim-treesitter-textobjects ------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
})

-- Настройка плагина
require("nvim-treesitter-textobjects").setup({
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
    },
    move = {
      enable = true,
      set_jumps = true,
    },
    swap = {
      enable = true,
    },
  },
})

-- select (выделение объектов)
local ts_select = require("nvim-treesitter-textobjects.select")

map({ "x", "o" }, "af", function()
  ts_select.select_textobject("@function.outer", "textobjects")
end, { desc = "Outer function" })

map({ "x", "o" }, "if", function()
  ts_select.select_textobject("@function.inner", "textobjects")
end, { desc = "Inner function" })

map({ "x", "o" }, "ac", function()
  ts_select.select_textobject("@class.outer", "textobjects")
end, { desc = "Outer class" })

map({ "x", "o" }, "ic", function()
  ts_select.select_textobject("@class.inner", "textobjects")
end, { desc = "Inner class" })

map({ "x", "o" }, "aO", function()
  ts_select.select_textobject("@loop.outer", "textobjects")
end, { desc = "Outer loop" })

map({ "x", "o" }, "iO", function()
  ts_select.select_textobject("@loop.inner", "textobjects")
end, { desc = "Inner loop" })

map({ "x", "o" }, "aD", function()
  ts_select.select_textobject("@conditional.outer", "textobjects")
end, { desc = "Outer conditional" })

map({ "x", "o" }, "iD", function()
  ts_select.select_textobject("@conditional.inner", "textobjects")
end, { desc = "Inner conditional" })

map({ "x", "o" }, "a,", function()
  ts_select.select_textobject("@parameter.outer", "textobjects")
end, { desc = "Outer parameter" })

map({ "x", "o" }, "i,", function()
  ts_select.select_textobject("@parameter.inner", "textobjects")
end, { desc = "Inner parameter" })

map({ "x", "o" }, "aC", function()
  ts_select.select_textobject("@call.outer", "textobjects")
end, { desc = "Outer call" })

map({ "x", "o" }, "iC", function()
  ts_select.select_textobject("@call.inner", "textobjects")
end, { desc = "Inner call" })

map({ "x", "o" }, "aB", function()
  ts_select.select_textobject("@block.outer", "textobjects")
end, { desc = "Outer block" })

map({ "x", "o" }, "iB", function()
  ts_select.select_textobject("@block.inner", "textobjects")
end, { desc = "Inner block" })

-- move (навигация)
local ts_move = require("nvim-treesitter-textobjects.move")

map({ "n", "x", "o" }, "]m", function()
  ts_move.goto_next_start("@function.outer", "textobjects")
end, { desc = "Next function start" })

map({ "n", "x", "o" }, "[m", function()
  ts_move.goto_previous_start("@function.outer", "textobjects")
end, { desc = "Prev function start" })

map({ "n", "x", "o" }, "]]", function()
  ts_move.goto_next_start("@class.outer", "textobjects")
end, { desc = "Next class start" })

map({ "n", "x", "o" }, "[[", function()
  ts_move.goto_previous_start("@class.outer", "textobjects")
end, { desc = "Prev class start" })

map({ "n", "x", "o" }, "]o", function()
  ts_move.goto_next_start({ "@loop.outer", "@conditional.outer" }, "textobjects")
end, { desc = "Next loop/conditional" })

map({ "n", "x", "o" }, "[o", function()
  ts_move.goto_previous_start({ "@loop.outer", "@conditional.outer" }, "textobjects")
end, { desc = "Prev loop/conditional" })

map({ "n", "x", "o" }, "]M", function()
  ts_move.goto_next_end("@function.outer", "textobjects")
end, { desc = "Next function end" })

map({ "n", "x", "o" }, "[M", function()
  ts_move.goto_previous_end("@function.outer", "textobjects")
end, { desc = "Prev function end" })

map({ "n", "x", "o" }, "][", function()
  ts_move.goto_next_end("@class.outer", "textobjects")
end, { desc = "Next class end" })

map({ "n", "x", "o" }, "[]", function()
  ts_move.goto_previous_end("@class.outer", "textobjects")
end, { desc = "Prev class end" })

-- swap (обмен)
local ts_swap = require("nvim-treesitter-textobjects.swap")

map("n", "<leader>sn", function()
  ts_swap.swap_next("@parameter.inner")
end, { desc = "Swap next parameter" })

map("n", "<leader>sp", function()
  ts_swap.swap_previous("@parameter.inner")
end, { desc = "Swap prev parameter" })

----------------------------------------------------------------------------------------

vim.pack.add({ 'https://github.com/chrisgrieser/nvim-various-textobjs' })

require("various-textobjs").setup({
  keymaps = {
    useDefaults = true
  }
})

-- ----------------------------------------------------------------------------------------
--
-- vim.pack.add({ 'https://github.com/nvim-mini/mini.move' })
--
-- require("mini.move").setup({})

---------------------------------------------------------------------
--------------------------- nvim-gomove -----------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = "https://github.com/booperlv/nvim-gomove" },
})

require("gomove").setup({
  -- Включаем стандартные бинды (Alt+hjkl для перемещения, Alt+Shift+hjkl для дублирования)
  map_defaults = true,

  -- Автоматически переставлять отступы при перемещении
  reindent = true,

  -- Объединять последовательные перемещения в одну отмену
  undojoin = true,

  -- Не двигать блоки за конец строки
  move_past_end_col = false,
})

-- ----------------------------------------------------------------------------------------
--
-- vim.pack.add({ 'https://github.com/nvim-mini/mini.splitjoin' })
--
-- require("mini.splitjoin").setup({})

---------------------------------------------------------------------
--------------------------- treesj ----------------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = "https://github.com/Wansmer/treesj" },
})

require("treesj").setup({
  -- Использовать стандартные бинды (отключаем, чтобы настроить свои)
  use_default_keymaps = false,

  -- Не форматировать узлы с синтаксическими ошибками
  check_syntax_error = true,

  -- Максимальная длина строки при join (если длиннее — не форматировать)
  max_join_length = 120,

  -- Поведение курсора: 'hold' — остаётся на месте, 'start' — в начало, 'end' — в конец
  cursor_behavior = 'hold',

  -- Показывать уведомления об ошибках
  notify = true,

  -- Поддержка dot-repeat (.)
  dot_repeat = true,

  -- Пресеты для языков (можно оставить по умолчанию)
  -- langs = {},
})

-- Бинды для treesj
local map = vim.keymap.set

-- Toggle: если блок однострочный — развернуть, если многострочный — свернуть
map("n", "<leader>j", function()
  require("treesj").toggle()
end, { desc = "Toggle split/join" })

-- Принудительно развернуть блок
map("n", "<leader>J", function()
  require("treesj").split()
end, { desc = "Split block" })

-- Принудительно свернуть блок
map("n", "<leader>s", function()
  require("treesj").join()
end, { desc = "Join block" })

----------------------------------------------------------------------------------------

vim.pack.add({ 'https://github.com/mizlan/iswap.nvim' })

require("iswap").setup({})

----------------------------------------------------------------------------------------

-- vim.pack.add({ 'https://github.com/folke/zen-mode.nvim' })
--
-- require("zen-mode").setup({})
--
-- vim.keymap.set("n", "<Leader>z", function()
--   require("zen-mode").toggle()
-- end, { desc = "Toggle Zen mode" })
