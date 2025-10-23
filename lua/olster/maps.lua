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
map('i', '<S-A-i>', '<Esc>A', { noremap = true, silent = true })
map('i', '<A-w>', '>')
map('i', '<A-q>', '<')


-- Telescope
map('n', '<leader>fl', ':Telescope find_files hidden=true<CR>')
map('n', '<leader>fs', ':Telescope live_grep<CR>')
map('n', '<leader>gc', ':Telescope git_commits<CR>')
map('n', '<leader>ld', ':Lspsaga peek_definition<CR>')
map('n', '<leader>kd', ':Telescope current_buffer_fuzzy_find<CR>')
map('n', '<A-w>', ':><CR>')
map('n', '<A-q>', ':<<CR>')
map('', 'sh', ':<C-w>h')
map('', 'sl', ':<C-w>l')


-- Symbols
map('n', '<leader><F8>', ':CocList outline<CR>')
map('n', '<leader>lre', ':Lspsaga rename<CR>')

map('n', '<leader>nt', ':NvimTreeOpen<CR>')



-- Custom Maps
map('n', '<leader>vx', ':lua require"treesitter-unit".select()<CR>')
map('n', '<leader>vd', ':lua require"treesitter-unit".delete()<CR>')
map('n', '<leader>vc', ':lua require"treesitter-unit".change()<CR>')
map('n', '<leader>re', ':lua require"nvim_rename".rename()<CR>')
vim.api.nvim_set_keymap('n', '<leader>fi', ":HopChar1<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fr', ":HopLine<CR>", { noremap = true, silent = true })


vim.api.nvim_set_keymap('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>1', ':BufferLineGoToBuffer 1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cl', ':bdelete<CR>', { noremap = true, silent = true })




vim.keymap.set('n', "'", function()
  local ok, char = pcall(vim.fn.getchar)
  if not ok then return end

  local key = vim.fn.nr2char(char)
  if key:match('[1-9]') then
    local cmd = string.format(':BufferLineGoToBuffer %s<CR>', key)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), 'n', true)
  else
    -- Si no fue un número, inserta "'" + la tecla como normal
    vim.api.nvim_feedkeys("'" .. key, 'n', false)
  end
end, { noremap = true, silent = true })
