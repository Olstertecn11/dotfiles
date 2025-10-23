local gcc_path = os.getenv("USERPROFILE") .. "\\scoop\\apps\\gcc\\current\\bin\\gcc.exe"
local gplusplus_path = os.getenv("USERPROFILE") .. "\\scoop\\apps\\gcc\\current\\bin\\g++.exe"


if not vim.fn.filereadable(gplusplus_path) == 1 and not vim.fn.filereadable(gcc_path) == 1 then
  print("✗ GCC y G++ no están configurados correctamente.")
end

-- También añadir la carpeta bin al PATH de Neovim
local bin_path = os.getenv("USERPROFILE") .. "\\scoop\\apps\\gcc\\current\\bin"
vim.env.PATH = bin_path .. ";" .. vim.env.PATH

-- Tu configuración de treesitter
local status, ts = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

ts.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    "markdown",
    "markdown_inline",
    "css",
    "html",
    "lua",
    "kotlin"
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
