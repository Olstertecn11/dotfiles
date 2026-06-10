-- 1. Autoinstalador automático de Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Inicialización de los plugins con Lazy
require("lazy").setup({
  -- Infraestructura base
  'nvim-lualine/lualine.nvim',
  'nvim-lua/plenary.nvim',
  'onsails/lspkind-nvim',
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  -- Temas estéticos
  "EdenEast/nightfox.nvim",
  'folke/tokyonight.nvim',
  'AlexvZyl/nordic.nvim',
  { "scottmckendry/cyberdream.nvim" },

  -- Treesitter y Apariencia
{
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  build = ":TSUpdate",
  lazy = false,
  priority = 1000,

  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "vue",
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "markdown",
        "markdown_inline",
        "php",
        "python",
        "kotlin",
      },

      sync_install = true,
      auto_install = false,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = false
      },
    })

    vim.filetype.add({
      extension = {
        vue = "vue",
      },
    })
  end,
},
  'kyazdani42/nvim-web-devicons',
  'norcalli/nvim-colorizer.lua',
  'sphamba/smear-cursor.nvim',
  {
    'echasnovski/mini.indentscope',
    config = function() require('mini.indentscope').setup() end
  },

  -- Navegación y Búsqueda
  'nvim-telescope/telescope.nvim',
  'nvim-telescope/telescope-file-browser.nvim',
  'nvim-tree/nvim-tree.lua',

  -- Utilidades de edición
  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',
  'folke/neodev.nvim',
  { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end },
  { 'kylechui/nvim-surround', version = "*" },

  -- Entorno PHP / Laravel / Blade
  'yuchanns/phpfmt.nvim',
  'jwalton512/vim-blade',
  {
    "aurum77/live-server.nvim",
    build = function() require "live_server.util".install() end,
    cmd = { "LiveServer", "LiveServerStart", "LiveServerStop" },
  },
  { 'github/copilot.vim', lazy = false },
  'mfussenegger/nvim-dap',

  -- UI y Layouts
  { "startup-nvim/startup.nvim", dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" } },
  { 
    'akinsho/bufferline.nvim', 
    version = "*", 
    dependencies = 'nvim-tree/nvim-web-devicons', 
    config = function() require('bufferline').setup {} end 
  },
  { 
    "akinsho/toggleterm.nvim", 
    version = '*', 
    config = function() require("toggleterm").setup() end 
  },

  -- =========================================================================
  -- EL NUEVO MOTOR EN RUST (Lazy lo maneja de forma perfecta de forma nativa)
  -- =========================================================================
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',
    opts = {
      keymap = { 
        preset = 'default',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = true }
      },
    },
  },
})
