---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	gh("nvim-tree/nvim-web-devicons"),
	gh("nvim-lualine/lualine.nvim"),
	gh("nvim-treesitter/nvim-treesitter"),
  gh("goolord/alpha-nvim"),
})

-- local startify = require("alpha.themes.startify")
-- startify.file_icons.provider = "devicons"
-- require("alpha").setup(
--   startify.config
-- )

vim.o.cmdheight =0
vim.pack.add({ "https://github.com/rachartier/tiny-cmdline.nvim" })
require("tiny-cmdline").setup()

---------------------------------------------------------------------
------------------------- LSP Status Flag ---------------------------
---------------------------------------------------------------------

-- Глобальная переменная для хранения статуса LSP
vim.g.lsp_loaded = false

-- Обновляем статус при подключении LSP
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.g.lsp_loaded = true
    -- Можно также сохранить имя сервера, если нужно
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    vim.g.lsp_client_name = client and client.name or "LSP"
  end,
})

---------------------------------------------------------------------
--------------------------- Lualine ---------------------------------
---------------------------------------------------------------------

local function lsp_status()
  local progress = vim.ui.progress_status()
  if progress ~= "" then
    -- Если LSP занят, показываем прогресс
    return "󰨊 " .. progress .. " "
  elseif vim.g.lsp_loaded then
    -- Если LSP загружен, но не активен, показываем зелёную иконку
    return "󰨊 "
  else
    -- Если LSP не загружен, ничего не показываем (или серую иконку)
    return ""
    -- или return "󰨊 "  -- можно всегда показывать
  end
end

vim.pack.add({
  { src = gh("nvim-lualine/lualine.nvim")},
})

local function lsp_progress()
  local progress = vim.ui.progress_status()
  if progress == "" then
    return ""  -- ничего не показывать, если LSP не активен
  end
  return " " .. progress .. " "  -- добавляем пробелы для отступа
end

require("lualine").setup({
  options = {
    theme = "auto",
    component_separators = { left = " ", right = " " },
    section_separators = { left = " ", right = " " },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { "filename" },
    lualine_x = {
      {
        lsp_status,
        cond = function()
          -- Можно показывать всегда, или только если есть LSP-клиенты
          return #vim.lsp.get_clients() > 0
        end,
        color = function()
          if vim.ui.progress_status() ~= "" then
            return { fg = "#f9e2af" } -- жёлтый для прогресса
          elseif vim.g.lsp_loaded then
            return { fg = "#a6e3a1" } -- зелёный для активного LSP
          else
            return { fg = "#6c7086" } -- серый для неактивного
          end
        end,
        padding = { left = 1, right = 1 },
      },
      "diagnostics",
    },
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
})

-- ---------------------------------------------------------------------
-- --------------------------- Neo-Tree --------------------------------
-- ---------------------------------------------------------------------
--
-- vim.pack.add({
-- 	{ src = gh("nvim-neo-tree/neo-tree.nvim") },
-- 	{ src = gh("nvim-lua/plenary.nvim") },
-- 	{ src = gh("MunifTanjim/nui.nvim") },
-- })
--
-- -- Функция-помощник для иконок (если у тебя уже есть - используй её)
-- local function get_icon(name)
-- 	local icons = {
-- 		FolderClosed = "",
-- 		FolderOpen = "",
-- 		FolderEmpty = "",
-- 		DefaultFile = "",
-- 		FileModified = "",
-- 		Git = "󰊢",
-- 		GitAdd = "",
-- 		GitDelete = "",
-- 		GitChange = "",
-- 		GitRenamed = "",
-- 		GitUntracked = "",
-- 		GitIgnored = "",
-- 		GitUnstaged = "",
-- 		GitStaged = "",
-- 		GitConflict = "",
-- 		FoldClosed = "",
-- 		FoldOpened = "",
-- 		Diagnostic = "󱩍",
-- 	}
-- 	return icons[name] or ""
-- end
--
-- -- Проверка наличия git
-- local git_available = vim.fn.executable("git") == 1
--
-- -- Настройка Neo-Tree
-- require("neo-tree").setup({
-- 	enable_git_status = git_available,
-- 	auto_clean_after_session_restore = true,
-- 	close_if_last_window = true,
-- 	popup_border_style = "",
--
-- 	-- Источники
-- 	sources = {
-- 		"filesystem",
-- 		"buffers",
-- 		git_available and "git_status" or nil,
-- 	},
--
-- 	-- Селектор источников в winbar
-- 	source_selector = {
-- 		winbar = true,
-- 		content_layout = "center",
-- 		sources = {
-- 			{ source = "filesystem", display_name = get_icon("FolderClosed") .. " Files" },
-- 			{ source = "buffers", display_name = get_icon("DefaultFile") .. " Bufs" },
-- 			{ source = "diagnostics", display_name = get_icon("Diagnostic") .. " Diag" },
-- 			git_available and { source = "git_status", display_name = get_icon("Git") .. " Git" } or nil,
-- 		},
-- 	},
--
-- 	-- Настройки компонентов
-- 	default_component_configs = {
-- 		indent = {
-- 			padding = 0,
-- 			expander_collapsed = get_icon("FoldClosed"),
-- 			expander_expanded = get_icon("FoldOpened"),
-- 		},
-- 		icon = {
-- 			folder_closed = get_icon("FolderClosed"),
-- 			folder_open = get_icon("FolderOpen"),
-- 			folder_empty = get_icon("FolderEmpty"),
-- 			default = get_icon("DefaultFile"),
-- 		},
-- 		modified = { symbol = get_icon("FileModified") },
-- 		git_status = {
-- 			symbols = {
-- 				added = get_icon("GitAdd"),
-- 				deleted = get_icon("GitDelete"),
-- 				modified = get_icon("GitChange"),
-- 				renamed = get_icon("GitRenamed"),
-- 				untracked = get_icon("GitUntracked"),
-- 				ignored = get_icon("GitIgnored"),
-- 				unstaged = get_icon("GitUnstaged"),
-- 				staged = get_icon("GitStaged"),
-- 				conflict = get_icon("GitConflict"),
-- 			},
-- 		},
-- 	},
--
-- 	-- Команды
-- 	commands = {
-- 		system_open = function(state)
-- 			vim.ui.open(state.tree:get_node():get_id())
-- 		end,
-- 		parent_or_close = function(state)
-- 			local node = state.tree:get_node()
-- 			if node:has_children() and node:is_expanded() then
-- 				state.commands.toggle_node(state)
-- 			else
-- 				require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
-- 			end
-- 		end,
-- 		child_or_open = function(state)
-- 			local node = state.tree:get_node()
-- 			if node:has_children() then
-- 				if not node:is_expanded() then
-- 					state.commands.toggle_node(state)
-- 				else
-- 					if node.type == "file" then
-- 						state.commands.open(state)
-- 					else
-- 						require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
-- 					end
-- 				end
-- 			else
-- 				state.commands.open(state)
-- 			end
-- 		end,
-- 		copy_selector = function(state)
-- 			local node = state.tree:get_node()
-- 			local filepath = node:get_id()
-- 			local filename = node.name
-- 			local modify = vim.fn.fnamemodify
--
-- 			local vals = {
-- 				["BASENAME"] = modify(filename, ":r"),
-- 				["EXTENSION"] = modify(filename, ":e"),
-- 				["FILENAME"] = filename,
-- 				["PATH (CWD)"] = modify(filepath, ":."),
-- 				["PATH (HOME)"] = modify(filepath, ":~"),
-- 				["PATH"] = filepath,
-- 				["URI"] = vim.uri_from_fname(filepath),
-- 			}
--
-- 			local options = vim.tbl_filter(function(val)
-- 				return vals[val] ~= ""
-- 			end, vim.tbl_keys(vals))
--
-- 			if vim.tbl_isempty(options) then
-- 				vim.notify("No values to copy", vim.log.levels.WARN)
-- 				return
-- 			end
--
-- 			table.sort(options)
-- 			vim.ui.select(options, {
-- 				prompt = "Choose to copy to clipboard:",
-- 				format_item = function(item)
-- 					return ("%s: %s"):format(item, vals[item])
-- 				end,
-- 			}, function(choice)
-- 				local result = vals[choice]
-- 				if result then
-- 					vim.notify(("Copied: `%s`"):format(result))
-- 					vim.fn.setreg("+", result)
-- 				end
-- 			end)
-- 		end,
-- 	},
--
-- 	-- Настройки окна
-- 	window = {
-- 		width = 30,
-- 		mappings = {
-- 			["<S-CR>"] = "system_open",
-- 			["<Space>"] = false,
-- 			["[b"] = "prev_source",
-- 			["]b"] = "next_source",
-- 			O = "system_open",
-- 			Y = "copy_selector",
-- 			h = "parent_or_close",
-- 			l = "child_or_open",
-- 		},
-- 		fuzzy_finder_mappings = {
-- 			["<C-J>"] = "move_cursor_down",
-- 			["<C-K>"] = "move_cursor_up",
-- 		},
-- 	},
--
-- 	-- Настройки файловой системы
-- 	filesystem = {
-- 		follow_current_file = { enabled = true },
-- 		filtered_items = { hide_gitignored = git_available },
-- 		hijack_netrw_behavior = "open_current",
-- 		use_libuv_file_watcher = vim.fn.has("win32") ~= 1,
-- 	},
--
-- 	-- Обработчики событий
-- 	event_handlers = {
-- 		{
-- 			event = "neo_tree_buffer_enter",
-- 			handler = function(_)
-- 				vim.opt_local.signcolumn = "auto"
-- 				vim.opt_local.foldcolumn = "0"
-- 			end,
-- 		},
-- 	},
-- })
--
-- -- Бинды для Neo-Tree
-- local map = vim.keymap.set
--
-- map("n", "<Leader>e", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Explorer" })
-- map("n", "<Leader>o", function()
-- 	if vim.bo.filetype == "neo-tree" then
-- 		vim.cmd.wincmd("p")
-- 	else
-- 		vim.cmd.Neotree("focus")
-- 	end
-- end, { desc = "Toggle Explorer Focus" })

----------------------------------------------------------------------
--------------------------- Which-Key --------------------------------
----------------------------------------------------------------------

vim.pack.add({
	{ src = gh("folke/which-key.nvim") },
})

require("which-key").setup({
	delay = 0,
	preset = "modern",
	icons = {
		breadcrumb = "»",
		separator = "➜",
		group = "+",
	},
	spec = {
		-- Группы
		{ "<Leader>f", group = "Find" },
		{ "<Leader>g", group = "Git" },
		{ "<Leader>l", group = "LSP" },
		{ "<Leader>x", group = "Diagnostics" },
		{ "<Leader>u", group = "UI" },
		{ "<Leader>b", group = "Buffers" },
		{ "<Leader>s", group = "Search/Replace" },
		{ "<Leader>e", group = "Explorer" },
	},
})

local wk = require("which-key")
wk.add({
	-- File
	{ "<Leader>fb", "<Cmd>FzfLua buffers<CR>", desc = "Buffers" },
	{ "<Leader>fo", "<Cmd>FzfLua oldfiles<CR>", desc = "Old files" },

	-- LSP
	{ "<Leader>la", vim.lsp.buf.code_action, desc = "Code action" },
	{ "<Leader>lr", vim.lsp.buf.rename, desc = "Rename" },
	{ "<Leader>lR", vim.lsp.buf.references, desc = "References" },
	{ "<Leader>ld", vim.lsp.buf.definition, desc = "Definition" },
})

-- ---------------------------------------------------------------------
-- --------------------------- Bufferline ------------------------------
-- ---------------------------------------------------------------------
--
-- vim.pack.add({
-- 	{ src = gh("akinsho/bufferline.nvim") },
-- })
--
-- local function bufdelete(bufnr)
-- 	-- Альтернатива Snacks.bufdelete
-- 	if vim.bo[bufnr].modified then
-- 		vim.cmd("confirm bdelete " .. bufnr)
-- 	else
-- 		vim.cmd("bdelete " .. bufnr)
-- 	end
-- end
--
-- require("bufferline").setup({
-- 	options = {
-- 		-- Команды закрытия
-- 		close_command = function(n)
-- 			bufdelete(n)
-- 		end,
-- 		right_mouse_command = function(n)
-- 			bufdelete(n)
-- 		end,
--
-- 		-- Диагностика LSP
-- 		diagnostics = "nvim_lsp",
-- 		diagnostics_indicator = function(_, _, diag)
-- 			local error = (diag.error and diag.error > 0) and "󰅚 " .. diag.error .. " " or ""
-- 			local warning = (diag.warning and diag.warning > 0) and "󰀪 " .. diag.warning or ""
-- 			return vim.trim(error .. warning)
-- 		end,
--
-- 		-- Отображение буферов
-- 		always_show_bufferline = false,
-- 		show_buffer_close_icons = true,
-- 		show_close_icon = false,
-- 		show_tab_indicators = true,
-- 		persist_buffer_sort = true,
-- 		enforce_regular_tabs = false,
-- 		separator_style = "slant", -- "slant", "thin", "thick"
--
-- 		-- Offsets для Neo-Tree и Snacks
-- 		offsets = {
-- 			{
-- 				filetype = "neo-tree",
-- 				text = "󰉋 Explorer",
-- 				highlight = "Directory",
-- 				text_align = "left",
-- 				separator = true,
-- 			},
-- 			{
-- 				filetype = "snacks_dashboard",
-- 				text = "󰖳 Dashboard",
-- 				highlight = "Title",
-- 				text_align = "center",
-- 				separator = true,
-- 			},
-- 			{
-- 				filetype = "snacks_layout_box",
-- 			},
-- 		},
--
-- 		-- Иконки для файлов (простой fallback)
-- 		get_element_icon = function(opts)
-- 			local ft = opts.filetype or ""
-- 			local icons = {
-- 				lua = "󰢱",
-- 				c = "󰙱",
-- 				cpp = "󰙲",
-- 				python = "󰌠",
-- 				sh = "󰅓",
-- 				bash = "󰅓",
-- 				zsh = "󰅓",
-- 				markdown = "󰍔",
-- 				json = "󰡦",
-- 				yaml = "󰓾",
-- 				toml = "󰒚",
-- 				gitcommit = "󰊢",
-- 				help = "󰋼",
-- 				neo_tree = "󰉋",
-- 				snacks_dashboard = "󰖳",
-- 			}
-- 			return icons[ft] or "󰈔" -- default file icon
-- 		end,
-- 	},
-- })
--
-- -- Включаем мышь
-- vim.opt.mouse = "a"
-- vim.opt.showtabline = 0
--
-- -- Бинды для bufferline
-- local map = vim.keymap.set
--
-- -- Навигация по буферам
-- map("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
-- map("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
-- map("n", "[b", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
-- map("n", "]b", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
--
-- -- Перемещение буферов
-- map("n", "[B", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move buffer prev" })
-- map("n", "]B", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move buffer next" })
--
-- -- Управление буферами
-- map("n", "<Leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle Pin" })
-- map("n", "<Leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete Non-Pinned Buffers" })
-- map("n", "<Leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete Buffers to the Right" })
-- map("n", "<Leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete Buffers to the Left" })
-- map("n", "<Leader>bj", "<Cmd>BufferLinePick<CR>", { desc = "Pick Buffer" })
--
-- -- Закрыть буфер
-- map("n", "<Leader>bd", function()
-- 	local bufnr = vim.api.nvim_get_current_buf()
-- 	local ft = vim.bo.filetype
-- 	if ft == "neo-tree" then
-- 		vim.cmd("Neotree close")
-- 	elseif ft == "snacks_dashboard" then
-- 		vim.cmd("q")
-- 	else
-- 		bufdelete(bufnr)
-- 	end
-- end, { desc = "Close buffer" })
--
-- -- Автообновление bufferline при добавлении/удалении буферов
-- vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
-- 	callback = function()
-- 		vim.schedule(function()
-- 			pcall(vim.cmd, "BufferLineRefresh")
-- 		end)
-- 	end,
-- })

-- Добавляем плагин
vim.pack.add({
  { src = "https://github.com/rachartier/tiny-glimmer.nvim" },
})

-- Базовая настройка (без лишнего шума)
require("tiny-glimmer").setup({
  -- Включаем анимации
  enabled = true,

  -- Отключаем для некоторых буферов, чтобы не мешали
  hijack_ft_disabled = {
    "alpha",
    "snacks_dashboard",
    "neo-tree",
    "TelescopePrompt",
  },

  -- Настройка конкретных операций
  overwrite = {
    -- Анимация при копировании (yank)
    yank = {
      enabled = true,
      default_animation = "fade", -- или "pulse"
    },
    -- Анимация при вставке (paste)
    paste = {
      enabled = true,
      default_animation = "reverse_fade",
    },
    -- Анимация при отмене/повторе (undo/redo)
    undo = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = { from_color = "DiffDelete" },
      },
    },
    redo = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = { from_color = "DiffAdd" },
      },
    },
    -- Анимация при поиске (можно выключить, если мешает)
    search = {
      enabled = false, -- Или true, если нравится
    },
  },

  -- Настройка внешнего вида анимаций (цвета)
  animations = {
    fade = {
      from_color = "Visual",
      to_color = "Normal",
      easing = "outQuad",
      max_duration = 300,
      min_duration = 200,
    },
    pulse = {
      from_color = "Visual",
      to_color = "Normal",
      pulse_count = 2,
    },
  },

  -- Прозрачный фон (если используешь)
  transparency_color = nil, -- Или "#1e1e2e" под свой фон
})

-- Опционально: бинды для управления анимациями (если понадобятся)
local map = vim.keymap.set
map("n", "<Leader>ue", "<Cmd>TinyGlimmer enable<CR>", { desc = "Enable animations" })
map("n", "<Leader>ud", "<Cmd>TinyGlimmer disable<CR>", { desc = "Disable animations" })

-- ---------------------------------------------------------------------
-- ----------------------------- nvim-ufo ------------------------------
-- ---------------------------------------------------------------------
--
-- vim.pack.add({
--   { src = "https://github.com/kevinhwang91/nvim-ufo" },
--   { src = "https://github.com/kevinhwang91/promise-async" },
-- })
--
-- -- Базовые настройки фолдинга для Neovim
-- vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:'
-- vim.opt.foldcolumn = "1"     -- показывать столбец для фолдов
-- vim.opt.foldlevel = 99       -- все блоки развёрнуты по умолчанию
-- vim.opt.foldlevelstart = 99  -- при открытии файла все развёрнуто
-- vim.opt.foldenable = true    -- фолдинг включён
--
-- -- Настройка ufo
-- require("ufo").setup({
--   -- Провайдеры: сначала LSP (самый точный), потом Treesitter, потом indent
--   provider_selector = function(bufnr, filetype, buftype)
--     return { "treesitter", "indent" }
--   end,
-- })
--
-- -- === Бинды для управления фолдами ===
--
-- local map = vim.keymap.set
--
-- -- Развернуть/свернуть всё
-- map("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
-- map("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
-- map("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
-- map("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds" })
--
-- -- Предпросмотр свёрнутого блока (K по умолчанию, но у тебя K занят под LSP hover)
-- -- Можно переназначить на другую клавишу или оставить как есть
-- map("n", "<Leader>fp", function()
--   local winid = require("ufo").peekFoldedLinesUnderCursor()
--   if not winid then
--     -- fallback на стандартный LSP hover (если надо)
--     vim.lsp.buf.hover()
--   end
-- end, { desc = "Peek folded lines" })


-- ---------------------------------------------------------------------
-- --------------------------- neoscroll -------------------------------
-- ---------------------------------------------------------------------
--
-- vim.pack.add({
--   { src = "https://github.com/karb94/neoscroll.nvim" },
-- })
--
-- require("neoscroll").setup({
--   -- Останавливаться в конце файла
--   stop_eof = true,
--
--   -- Уважать `scrolloff` (чтобы не упираться в край)
--   respect_scrolloff = false,
--
--   -- Прокручивать курсор, даже если окно не может прокрутиться дальше
--   cursor_scrolls_alone = true,
--
--   -- Глобальный множитель длительности анимации
--   duration_multiplier = 1.0,
--
--   -- Тип анимации по умолчанию
--   easing = "sine",
--
--   -- Маппинги, которые будут переопределены
--   mappings = {
--     "<C-u>",
--     "<C-d>",
--     "<C-b>",
--     "<C-f>",
--     "<C-y>",
--     "<C-e>",
--     "zt",
--     "zz",
--     "zb",
--   },
--
--   -- Отключаем производительность (она не нужна на современных машинах)
--   performance_mode = false,
-- })
--
-- -- Кастомные маппинги с разной длительностью для разных действий
-- local neoscroll = require("neoscroll")
-- local map = vim.keymap.set
-- local modes = { "n", "v", "x" }
--
-- -- Настройка плавности для каждой команды
-- map(modes, "<C-u>", function()
--   neoscroll.ctrl_u({ duration = 250, easing = "sine" })
-- end, { desc = "Smooth scroll up" })
--
-- map(modes, "<C-d>", function()
--   neoscroll.ctrl_d({ duration = 250, easing = "sine" })
-- end, { desc = "Smooth scroll down" })
--
-- map(modes, "<C-b>", function()
--   neoscroll.ctrl_b({ duration = 450, easing = "circular" })
-- end, { desc = "Smooth page up" })
--
-- map(modes, "<C-f>", function()
--   neoscroll.ctrl_f({ duration = 450, easing = "circular" })
-- end, { desc = "Smooth page down" })
--
-- map(modes, "<C-y>", function()
--   neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 })
-- end, { desc = "Smooth scroll line up" })
--
-- map(modes, "<C-e>", function()
--   neoscroll.scroll(0.1, { move_cursor = false, duration = 100 })
-- end, { desc = "Smooth scroll line down" })
--
-- map("n", "zt", function()
--   neoscroll.zt({ half_win_duration = 250 })
-- end, { desc = "Smooth zt" })
--
-- map("n", "zz", function()
--   neoscroll.zz({ half_win_duration = 250 })
-- end, { desc = "Smooth zz" })
--
-- map("n", "zb", function()
--   neoscroll.zb({ half_win_duration = 250 })
-- end, { desc = "Smooth zb" })

-- ---------------------------------------------------------------------
-- --------------------------- mini.animate ----------------------------
-- ---------------------------------------------------------------------
--
-- vim.pack.add({
--   { src = "https://github.com/nvim-mini/mini.animate" },
-- })
--
-- require("mini.animate").setup({
--   resize = {
--     enable = true,
--     timing = function(_, _) return 15 end,
--     subresize = function(sizes_from, sizes_to)
--       -- sizes_from и sizes_to - таблицы с размерами окон
--       -- Возвращаем массив промежуточных состояний
--       local steps = {}
--       local n_steps = 20
--
--       for i = 1, n_steps do
--         local step_state = {}
--         for win_id, size_to in pairs(sizes_to) do
--           local size_from = sizes_from[win_id]
--           if size_from then
--             -- Интерполируем размеры
--             local progress = i / n_steps
--             step_state[win_id] = {
--               width = math.floor(size_from.width + (size_to.width - size_from.width) * progress),
--               height = math.floor(size_from.height + (size_to.height - size_from.height) * progress),
--             }
--           end
--         end
--         steps[i] = step_state
--       end
--
--       return steps
--     end,
--   },
--
--   open = {
--     enable = true,
--     timing = function(_, _)
--       return 15
--     end,
--     winblend = function(step, total_steps)
--       local progress = step / total_steps
--       return math.floor(80 + 20 * progress)
--     end,
--   },
--
--   close = {
--     enable = true,
--     timing = function(_, _)
--       return 15
--     end,
--     winblend = function(step, total_steps)
--       local progress = step / total_steps
--       return math.floor(100 - 20 * progress)
--     end,
--   },
--
--   cursor = {
--     enable = false,
--     timing = function(_, _)
--       return 15
--     end,
--     path = function(_, _)
--       return 30
--     end,
--   },
--
--   scroll = {
--     enable = false,
--     timing = function(_, _)
--       return 15
--     end,
--     subscroll = function(total_steps)
--       local steps = {}
--       for i = 1, 20 do
--         steps[i] = 1
--       end
--       return steps
--     end,
--   },
-- })
