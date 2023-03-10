require('olster.base')
require('olster.plugins')
require('olster.maps')

local has = vim.fn.has

local is_win = has "win32"


if is_win then 
  require('olster.windows')
end





