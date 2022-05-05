call plug#begin('~/.vim/plugged')
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'ryanoasis/vim-devicons'
    Plug 'tpope/vim-commentary'
    Plug 'ful1e5/onedark.nvim'
    Plug 'overcache/NeoSolarized'	
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'yuezk/vim-js'
    Plug 'maxmellon/vim-jsx-pretty'
    Plug 'preservim/nerdtree'
    Plug 'preservim/tagbar'
    Plug 'kdheepak/tabline.nvim'
    " lsp plugins
    Plug 'neovim/nvim-lspconfig'
    Plug 'folke/lsp-colors.nvim'
    Plug 'tami5/lspsaga.nvim'
    Plug 'williamboman/nvim-lsp-installer'
call plug#end()



