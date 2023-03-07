local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  --Packer
  use('wbthomason/packer.nvim')
  -- Lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use "nvim-tree/nvim-web-devicons"

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- Commentary
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }


  -- Tressiter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ':TSUpdate',
    config = function() require('nvim-treesitter.configs').setup({
        ensure_installed = { "lua" },
        sync_install = true,
        auto_install = true,
      })
    end,
  }


  --Auto Pairs
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'

  -- CMP
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  -- Lspsaga
  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require("lspsaga").setup({})
    end,
    requires = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" }
    }
  })
  -- Snippets
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'


  -- Colorscheme
  use { "catppuccin/nvim", as = "catppuccin" }
  use 'folke/lsp-colors.nvim'


  -- Lspkind
  use 'onsails/lspkind.nvim'


  -- Nav
  use 'simrat39/symbols-outline.nvim'
end)
