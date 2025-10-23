local telescope = require('telescope')
local actions = require('telescope.actions')

-- Función para leer archivo de configuración local
local function read_local_config()
  local config_file = vim.fn.getcwd() .. '/.telescope-nvim'
  local file = io.open(config_file, 'r')

  if not file then
    return nil
  end

  local content = file:read('*a')
  file:close()

  local patterns = {}
  for line in content:gmatch('[^\r\n]+') do
    local clean_line = line:match('^%s*(.-)%s*$')           -- Trim espacios
    if clean_line ~= '' and not clean_line:match('^#') then -- Ignorar líneas vacías y comentarios
      table.insert(patterns, clean_line)
    end
  end

  return patterns
end

-- Configuración base por defecto
local default_ignore_patterns = {
  "^vendor/",
  "^node_modules/",
  "^%.git/",
  "^%.idea/",
  "^%.vscode/",
  "^%.history/",
  "%.log$",
  "%.lock$",
  "%.sqlite$",
  "^storage/",
  "^bootstrap/",
  "^public/storage",
  "^public/vendor",
}

-- Combinar configuraciones globales y locales
local function get_ignore_patterns()
  local local_patterns = read_local_config() or {}
  local merged_patterns = {}

  -- Copiar patrones por defecto
  for _, pattern in ipairs(default_ignore_patterns) do
    table.insert(merged_patterns, pattern)
  end

  -- Agregar patrones locales
  for _, pattern in ipairs(local_patterns) do
    table.insert(merged_patterns, pattern)
  end

  return merged_patterns
end

-- Configurar Telescope con los patrones combinados
telescope.setup({
  defaults = {
    file_ignore_patterns = get_ignore_patterns(),
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_to_qflist,
        ["<Esc>"] = actions.close,
      },
    },
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        preview_width = 0.6,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      no_ignore = false,
      find_command = {
        "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git",
        "--exclude", "node_modules",
        "--exclude", "vendor",
        "--exclude", ".git"
      },
    },
    live_grep = {
      additional_args = function()
        local args = {}
        local patterns = get_ignore_patterns()

        for _, pattern in ipairs(patterns) do
          -- Convertir patrones para rg
          local rg_pattern = pattern
              :gsub("%%", "*")   -- Convertir % a *
              :gsub("^%^", "")   -- Remover ^ inicial
              :gsub("%$$", "")   -- Remover $ final
              :gsub("/%.%*", "") -- Remover /* al final

          if rg_pattern ~= "" then
            table.insert(args, "--glob")
            table.insert(args, "!" .. rg_pattern)
          end
        end

        return args
      end,
    },
  },
})

-- Cargar extensiones si las tienes
local ok, _ = pcall(require, 'telescope._extensions')
if ok then
  -- telescope.load_extension('fzf')
  telescope.load_extension('file_browser')
end

-- Comando personalizado para debug
vim.api.nvim_create_user_command('TelescopeIgnorePatterns', function()
  local patterns = get_ignore_patterns()
  print("=== Patrones ignorados por Telescope ===")
  for i, pattern in ipairs(patterns) do
    print(string.format("%d. %s", i, pattern))
  end
  print("========================================")
end, {})
