---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo)
	return "https://github.com/" .. repo
end

local map = vim.keymap.set

-- vim.pack.add({
-- 	{ src = gh("ibhagwan/fzf-lua") },
-- })
--
-- require("fzf-lua").setup({})
--
-- local fzf = require("fzf-lua")
--
-- -- map("n", "<leader><leader>", fzf.files)
-- map("n", "<leader>/", fzf.live_grep, { desc = "Grep" })
-- map("n", "<Leader>f<CR>", fzf.resume, { desc = "Resume previous search" })
-- map("n", "<Leader>f'", fzf.marks, { desc = "Find marks" })
-- map("n", "<Leader>f/", fzf.lgrep_curbuf, { desc = "Find in current buffer" })
--
-- map("n", "<Leader>fb", fzf.buffers, { desc = "Find buffers" })
-- map("n", "<Leader>fc", fzf.grep_cword, { desc = "Find word under cursor" })
-- map("n", "<Leader>fC", fzf.commands, { desc = "Find commands" })
-- -- map("n", "<Leader>ff", fzf.files, { desc = "Find files" })
-- map("n", "<Leader>fh", fzf.helptags, { desc = "Find help" })
-- map("n", "<Leader>fk", fzf.keymaps, { desc = "Find keymaps" })
-- map("n", "<Leader>fm", fzf.manpages, { desc = "Find man" })
-- map("n", "<Leader>fo", fzf.oldfiles, { desc = "Find history" })
-- map("n", "<Leader>fr", fzf.registers, { desc = "Find registers" })
--
-- map("n", "<Leader>cf",
--   function()
--     require("fzf-lua").files({
--       prompt = "Config> ",
--       cwd = vim.fn.stdpath "config",
--     })
--   end,
--   { desc = "Find in config" })

vim.pack.add({ 'https://github.com/dmtrKovalenko/fff.nvim' })

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('fff.nvim') end
      require('fff.download').download_or_build_binary()
    end
  end,
})

vim.g.fff = {
  lazy_sync = true,
  debug = { enabled = true, show_scores = true },
}

local fff = require("fff")

-- Поиск файлов
map("n", "<Leader><Leader>", function()
  fff.find_files()
end, { desc = "Find files" })

map("n", "<Leader>ff", function()
  fff.find_files()
end, { desc = "Find files" })

map("n", "<Leader>fF", function()
  fff.find_files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Find files (current dir)" })

-- Поиск по содержимому (grep)
map("n", "<Leader>fg", function()
  fff.live_grep()
end, { desc = "Find with grep" })

map("n", "<Leader>/", function()
  fff.live_grep()
end, { desc = "Find with grep" })

map("n", "<Leader>fG", function()
  fff.live_grep({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Find with grep (cwd)"})

-- Поиск слова под курсором (Normal mode)
map("n", "<Leader>fw", function()
  fff.live_grep_under_cursor()
end, { desc = "Find word under cursor" })

-- Поиск выделенного текста (Visual mode)
map("x", "<Leader>fw", function()
  fff.live_grep_under_cursor()
end, { desc = "Find selected text" })

-- Поиск в конкретной папке (конфиг)
map("n", "<Leader>cf", function()
  fff.find_files({
    cwd = vim.fn.stdpath("config"),
    prompt = "Config> ",
  })
end, { desc = "Find in config" })

-- Grep по конфигу
map("n", "<Leader>cg", function()
  fff.live_grep({
    cwd = vim.fn.stdpath("config"),
    prompt = "Config grep> ",
  })
end, { desc = "Grep in config" })

-- Поиск в конкретной папке (конфиг)
map("n", "<Leader>fa", function()
  fff.find_files({
    cwd = vim.fn.stdpath("config"),
    prompt = "Config> ",
  })
end, { desc = "Find in config" })

-- Принудительный рескан (если индекс устарел)
map("n", "<Leader>fr", function()
  fff.scan_files()
end, { desc = "Rescan files" })

---------------------------------------------------------------------
------------------------------ Oil ----------------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
})

require("oil").setup({
  -- Открывать oil в плавающем окне вместо сплита
  use_default_keymaps = false, -- отключаем стандартные бинды, ставим свои

  view_options = {
    -- Показывать скрытые файлы
    show_hidden = true,
    -- Естественная сортировка (как в файловом менеджере)
    natural_order = true,
  },
  win_options = {
    winbar = "%{v:lua.require('oil').get_current_dir()}",
  },
    -- Настройки для буфера oil
  keymaps = {
    ["<Esc>"] = "actions.close",
    ["q"]     = "actions.close",
    ["<Leader>e"]     = "actions.close",
    ["<CR>"]  = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-r>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.cd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
})

-- Открыть oil (текущая директория)
map("n", "<Leader>e", "<Cmd>Oil<CR>", { desc = "Oil: open current dir" })

-- Открыть oil в текущей директории файла
map("n", "<Leader>E", function()
  vim.cmd("Oil " .. vim.fn.expand("%:p:h"))
end, { desc = "Oil: open file dir" })

-- TODO Сделать показ пути oil nvim

---------------------------------------------------------------------
----------------------------- Grug FAR ------------------------------
---------------------------------------------------------------------

vim.pack.add({
  { src = "https://github.com/MagicDuck/grug-far.nvim" },
})

-- Функция для открытия Grug FAR (адаптирована из AstroNvim)
local default_opts = { instanceName = "main" }

local function grug_far_open(opts, with_visual)
  local grug_far = require("grug-far")
  opts = vim.tbl_extend("force", default_opts, opts or {})

  if not grug_far.has_instance(opts.instanceName) then
    grug_far.open(opts)
  else
    if with_visual then
      if not opts.prefills then opts.prefills = {} end
      opts.prefills.search = grug_far.get_current_visual_selection()
    end
    grug_far.open_instance(opts.instanceName)
    if opts.prefills then
      grug_far.update_instance_prefills(opts.instanceName, opts.prefills, false)
    end
  end
end

-- Настройка Grug FAR
require("grug-far").setup({
  transient = true,
  icons = {
    enabled = true,
  },
})

-- === Бинды для Grug FAR ===

local map = vim.keymap.set

-- Поиск и замена по всему проекту
map("n", "<Leader>ss", function()
  grug_far_open()
end, { desc = "Search/Replace workspace" })

-- Поиск и замена в текущем файле
map("n", "<Leader>sf", function()
  local filter = vim.api.nvim_buf_get_name(0)
  if filter ~= "" then
    grug_far_open({ prefills = { paths = filter } })
  else
    grug_far_open()
  end
end, { desc = "Search/Replace file" })

-- Поиск и замена по типу файла
map("n", "<Leader>se", function()
  local ext = vim.fn.expand("%:e")
  grug_far_open({
    prefills = { filesFilter = ext ~= "" and "*." .. ext or nil },
  })
end, { desc = "Search/Replace filetype" })

-- Поиск и замена текущего слова под курсором
map("n", "<Leader>sw", function()
  local current_word = vim.fn.expand("<cword>")
  if current_word ~= "" then
    grug_far_open({
      startCursorRow = 4,
      prefills = { search = current_word },
    })
  else
    vim.notify("No word under cursor", vim.log.levels.WARN, { title = "Grug-far" })
  end
end, { desc = "Replace current word" })

-- Поиск и замена выделенного текста (Visual mode)
map("x", "<Leader>s", function()
  grug_far_open(nil, true)
end, { desc = "Replace selection" })

-- Поиск и замена в текущей директории (адаптировано для oil/neo-tree)
map("n", "<Leader>sd", function()
  local dir = vim.fn.expand("%:p:h")
  grug_far_open({ prefills = { paths = dir } })
end, { desc = "Search/Replace current dir" })
