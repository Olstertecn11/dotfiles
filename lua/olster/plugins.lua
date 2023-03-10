local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use 'nvim-lualine/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons' 

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { {'nvim-lua/plenary.nvim'} }
  } 



  -- colorschemes
  use { "catppuccin/nvim", as = "catppuccin" }
  use 'folke/tokyonight.nvim'


  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
  }

  use {'neoclide/coc.nvim', branch = 'release'}






end)
