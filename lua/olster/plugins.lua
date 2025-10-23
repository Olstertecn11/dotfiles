local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nvim-lualine/lualine.nvim' -- Statusline
  use 'nvim-lua/plenary.nvim'     -- Common utilities
  use 'onsails/lspkind-nvim'      -- vscode-like pictograms
  use 'neovim/nvim-lspconfig'     -- LSP
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use "EdenEast/nightfox.nvim" -- Packer

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
  use 'kyazdani42/nvim-web-devicons' -- File icons
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'

  use 'norcalli/nvim-colorizer.lua'


  use { 'neoclide/coc.nvim', branch = 'release' }
  use 'folke/tokyonight.nvim'
  use 'nvim-tree/nvim-tree.lua'
  use 'preservim/tagbar'
  use "folke/neodev.nvim"
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  use('yuchanns/phpfmt.nvim')


  use({
    "startup-nvim/startup.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  })


  use {
    'echasnovski/mini.indentscope',
    config = function()
      require('mini.indentscope').setup({
        -- Aquí puedes añadir cualquier configuración adicional que necesites
      })
    end
  }


  use 'jwalton512/vim-blade'
  use { 'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {}
    end
  }

  use({
    "stevearc/aerial.nvim",
    config = function()
      require("aerial").setup()
    end,
  })



  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }


  use 'sphamba/smear-cursor.nvim'

  use 'mfussenegger/nvim-dap'
  use 'github/copilot.vim'
  use({
    "aurum77/live-server.nvim",
    run = function()
      require "live_server.util".install()
    end,
    cmd = { "LiveServer", "LiveServerStart", "LiveServerStop" },
  })
  use({
    "kylechui/nvim-surround",
    tag = "*"
  })

  use 'AlexvZyl/nordic.nvim'
  use { "scottmckendry/cyberdream.nvim" }

  use { "akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end }
end)
