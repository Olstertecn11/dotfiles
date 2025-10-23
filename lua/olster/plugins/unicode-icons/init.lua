local M = {}
local win_prev = nil
local buf_prev = nil

local function to_unicode(code)
  local hex = code:gsub("^\\u", "")
  local num = tonumber(hex, 16)
  return vim.fn.nr2char(num, true)
end

local function show_unicode_if_needed()
  local current_line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  -- Buscar si el cursor está sobre un código \uXXXX
  for code in current_line:gmatch("\\u[0-9a-fA-F]+") do
    local start_pos, end_pos = current_line:find(code, 1, true)
    if start_pos and col >= start_pos - 1 and col <= end_pos then
      local icon = to_unicode(code)

      -- Si ya hay una ventana mostrando el mismo icono, no hagas nada
      if win_prev and vim.api.nvim_win_is_valid(win_prev) and buf_prev then
        local lines = vim.api.nvim_buf_get_lines(buf_prev, 0, -1, false)
        if lines[1] == icon then
          return
        end
      end

      -- Cerrar ventana previa si existe
      if win_prev and vim.api.nvim_win_is_valid(win_prev) then
        vim.api.nvim_win_close(win_prev, true)
        win_prev = nil
      end

      -- Crear nueva ventana con el icono
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { icon })

      local opts = {
        relative = "cursor",
        width = 3,
        height = 1,
        col = 1,
        row = -1,
        style = "minimal",
        border = "single",
      }

      win_prev = vim.api.nvim_open_win(buf, false, opts)
      buf_prev = buf
      return
    end
  end

  -- Si no está sobre un unicode, cerrar ventana previa
  if win_prev and vim.api.nvim_win_is_valid(win_prev) then
    vim.api.nvim_win_close(win_prev, true)
    win_prev = nil
    buf_prev = nil
  end
end

M.start_autocmd = function()
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = show_unicode_if_needed,
    desc = "Muestra iconos unicode flotantes al pasar el cursor sobre ellos",
  })
  print("Unicode listener iniciado ✅")
end

return M
