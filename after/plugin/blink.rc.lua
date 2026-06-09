local status, blink = pcall(require, "blink.cmp")
if not status then
  return
end

blink.setup({
  -- Mapeos clásicos e intuitivos
  keymap = {
    preset = 'default',
    ['<C-space>'] = { 'show', 'show_documentation', 'hide' },
    ['<CR>'] = { 'accept', 'fallback' },
    ['<Tab>'] = { 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
  },

  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono'
  },

  -- Fuentes de autocompletado ordenadas por prioridad
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  -- Ventanas flotantes estéticas para la documentación
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    ghost_text = { enable = true }
  },
})
