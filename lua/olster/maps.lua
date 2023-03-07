local function map(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)

end

vim.g.mapleader = ' '

-- Utils
map('n', '<leader>so', ':source %<CR>')
map('n', '<leader>t', ':t . <CR>')
map('i', 'kk', '<Esc>')


-- Telescope
map('n', '<leader>ff', ':Telescope find_files<CR>')
map('n', '<leader>fs', ':Telescope live_grep<CR>')
map('n', '<leader>gc', ':Telescope git_commits<CR>')
