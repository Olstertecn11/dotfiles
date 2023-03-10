-- Mappings.
local opts = { noremap = true, silent = true }


local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
end

local lsp_flags = {
  debounce_text_changes = 150,
}

require('lspconfig')['pyright'].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}
require('lspconfig')['tsserver'].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}

require('lspconfig')['lua_ls'].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}


require('lspconfig')['ccls'].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}
