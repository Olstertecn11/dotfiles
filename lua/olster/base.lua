-- ~/.config/nvim/lua/olster/base.lua

vim.scriptencoding = "utf-8"

-- Encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Números
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- UI
vim.opt.title = true
vim.opt.mouse = "a"
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.scrolloff = 10
vim.opt.wrap = false
vim.opt.hlsearch = true
vim.opt.inccommand = "split"

-- Búsqueda
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Archivos
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }

-- Paths
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*", "*/dist/*", "*/build/*", "*/.git/*" })
vim.opt.isfname:append({ "(", ")" })

-- Indentación base
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.smarttab = true
vim.opt.expandtab = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.backspace = { "start", "eol", "indent" }

-- Activar plugins e indentación por tipo de archivo
vim.cmd("filetype plugin indent on")

-- Configuración específica por lenguaje
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "lua",
    "vue",
    "html",
    "css",
    "scss",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "json",
  },
  callback = function()
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
    vim.opt_local.expandtab = true

    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Solo si estás en Windows
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  vim.opt.shell = "powershell"

  vim.g.tagbar_ctags_bin = "C:\\Program Files\\ctags\\ctags.exe"
end
