local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ' '

-- Utils
map('n', '<leader>so', ':source %<CR>')
map('n', '<leader>t', ':t . <CR>')
map('n', '<leader>w', ':w<CR>')
map('n', '<leader>q', ':q<CR>')
map('n', '<leader>wq', ':wq!<CR>')
map('i', 'kk', '<Esc>')


-- Telescope
map('n', '<leader>fl', ':Telescope find_files<CR>')
map('n', '<leader>fs', ':Telescope live_grep<CR>')
map('n', '<leader>gc', ':Telescope git_commits<CR>')
map('n', '<leader>pd', ':Lspsaga peek_definition<CR>')
map('n', '<A-w>', ':><CR>')
map('n', '<A-q>', ':<<CR>')
map('', 'sh', ':<C-w>h')
map('', 'sl', ':<C-w>l')


-- Symbols
map('n', '<leader>tb', ':SymbolsOutline<CR>')
map('n', '<leader>lre', ':Lspsaga rename<CR>')

map('n', '<leader>nt', ':NvimTreeOpen<CR>')



-- Custom Maps
map('n', '<leader>vx', ':lua require"treesitter-unit".select()<CR>')
map('n', '<leader>vd', ':lua require"treesitter-unit".delete()<CR>')
map('n', '<leader>vc', ':lua require"treesitter-unit".change()<CR>')
map('n', '<leader>re', ':lua require"nvim_rename".rename()<CR>')
