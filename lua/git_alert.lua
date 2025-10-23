local M = {}

-- Función para obtener la rama actual
local function get_git_branch()
  local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
  -- Ajuste para que "2>nul" funcione en Windows, y "2>/dev/null" en Linux/mac
  local command = is_windows and "git rev-parse --abbrev-ref HEAD 2>nul"
      or "git rev-parse --abbrev-ref HEAD 2>/dev/null"

  local handle = io.popen(command)
  if not handle then
    return nil
  end

  -- Lee la salida completa (posiblemente con salto de línea)
  local branch = handle:read("*a")
  handle:close()

  if not branch then
    return nil
  end

  -- Elimina espacios y saltos de línea
  branch = branch:gsub("%s+", "")

  -- Si queda vacío, regresamos nil
  if branch == "" then
    return nil
  end

  return branch
end

-- Mostrar advertencia en ventana flotante
local function show_floating_warning(message)
  local buf = vim.api.nvim_create_buf(false, true) -- buffer temporal
  local width = math.min(50, vim.o.columns)
  local height = 1
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    anchor = "NW",
    style = "minimal",
    border = "rounded"
  }
  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { message })

  -- Cierra la ventana flotante después de 2 segundos
  vim.defer_fn(function()
    vim.api.nvim_win_close(win, true)
  end, 2000)
end

-- Bloquea la escritura si la rama es dev
local function block_writing()
  local branch = get_git_branch()

  -- Si no pudo leer la rama (nil) o no es 'dev', no hacemos nada
  if branch ~= "dev" then
    return
  end

  -- Si la rama es dev, mostramos advertencia y salimos de modo inserción
  show_floating_warning("⚠️ Estás en la rama 'dev', escritura bloqueada.")
  vim.api.nvim_input("<Esc>")                         -- Sale del modo de inserción
  vim.api.nvim_buf_set_option(0, 'modifiable', false) -- Impide modificar
end

-- Configurar autocmd
function M.setup()
  -- Verificación en InsertEnter (cuando entras a modo inserción)
  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = block_writing,
  })
end

return M
