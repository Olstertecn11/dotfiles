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


  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
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
      }) end,
    }


  --Auto Pairs
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'


end)

