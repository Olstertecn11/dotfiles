require('olster.base')
require('olster.highlights')
require('olster.maps')
require('olster.plugins')
require('olster.custom_plugins')
require('git_alert').setup()

local has = vim.fn.has
local is_win = has "win32"

if is_win then
  require('olster.windows')
end
