local function set_treesitter_highlights()
  -- Vue / HTML tags
  vim.api.nvim_set_hl(0, "@tag", { link = "Type" })
  vim.api.nvim_set_hl(0, "@tag.vue", { link = "Type" })
  vim.api.nvim_set_hl(0, "@tag.builtin", { link = "Keyword" })
  vim.api.nvim_set_hl(0, "@tag.builtin.vue", { link = "Keyword" })
  vim.api.nvim_set_hl(0, "@tag.attribute", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "@tag.attribute.vue", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "@tag.delimiter", { link = "Delimiter" })
  vim.api.nvim_set_hl(0, "@tag.delimiter.vue", { link = "Delimiter" })

  -- Atributos / props / directivas
  vim.api.nvim_set_hl(0, "@attribute", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "@property", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "@property.vue", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "@operator", { link = "Operator" })

  -- Variables / funciones
  vim.api.nvim_set_hl(0, "@variable", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "@variable.member", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "@function", { link = "Function" })
  vim.api.nvim_set_hl(0, "@function.call", { link = "Function" })
  vim.api.nvim_set_hl(0, "@constructor", { link = "Special" })

  -- Keywords / condicionales / repeticiones
  vim.api.nvim_set_hl(0, "@keyword", { link = "Keyword" })
  vim.api.nvim_set_hl(0, "@keyword.conditional", { link = "Conditional" })
  vim.api.nvim_set_hl(0, "@keyword.repeat", { link = "Repeat" })
  vim.api.nvim_set_hl(0, "@keyword.function", { link = "Keyword" })

  -- Strings / números / booleanos
  vim.api.nvim_set_hl(0, "@string", { link = "String" })
  vim.api.nvim_set_hl(0, "@number", { link = "Number" })
  vim.api.nvim_set_hl(0, "@boolean", { link = "Boolean" })

  -- Tipos TS
  vim.api.nvim_set_hl(0, "@type", { link = "Type" })
  vim.api.nvim_set_hl(0, "@type.builtin", { link = "Type" })

  -- Comentarios
  vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })
  vim.api.nvim_set_hl(0, "@comment.documentation", { link = "Comment" })
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  callback = set_treesitter_highlights,
})

set_treesitter_highlights()
