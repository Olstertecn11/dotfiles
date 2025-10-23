local toggleterm = require("toggleterm")

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<C-\>]], -- Ctrl+\ para abrir/cerrar
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float", -- puede ser 'vertical' | 'horizontal' | 'tab' | 'float'
  close_on_exit = true,
  shell = vim.o.shell, -- toma tu shell de Neovim (usamos pwsh más abajo)
  float_opts = {
    border = "curved",
    winblend = 3,
  },
})

-- Establece PowerShell como shell por defecto en Windows
if vim.fn.has("win32") == 1 then
  vim.opt.shell = "pwsh"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end

-- Terminal personalizada para lazygit (si lo tienes)
local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({
  cmd = "lazygit",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "double",
  },
})

local pwsh = Terminal:new({
  cmd = "pwsh",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "double",
  },
})

function _lazygit_toggle()
  lazygit:toggle()
end

function _pwsh_toggle()
  pwsh:toggle()
end

-- Mapear una tecla para abrir lazygit
vim.keymap.set("n", "<leader>gg", _lazygit_toggle, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tt", _pwsh_toggle, { noremap = true, silent = true })
